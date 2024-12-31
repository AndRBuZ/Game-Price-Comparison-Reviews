class SteamApiService
  BASE_URL = "https://store.steampowered.com/".freeze

  def initialize(game_id)
    @game_id = game_id
    @connection = Faraday.new(url: BASE_URL) do |faraday|
      faraday.request :url_encoded
      faraday.response :json
      faraday.adapter Faraday.default_adapter
    end
  end

  # Fetches detailed game information and saves it to the database.
  # The method retrieves the full game data, processes it, and delegates saving the data
  # to the GameDataHandler service.
  def fetch_game_details
    marketplace = Marketplace.find_by(name: "Steam")
    fetch_data do |data|
      game_data = process_full_data(data["data"])
      GameDataSaver.new(game_data, marketplace).process_and_save
    end
  end

  # Updates the price of a game in the database
  def update_price
    fetch_data(filters: "price_overview") do |data|
      price = process_price(data["data"])
      game_marketplace = GameMarketplace.find_by(steam_id: @game_id)
      game_marketplace.update!(price: price)
    end
  end

  private

  def fetch_data(filters: nil, &block)
    params = { appids: @game_id, cc: "US", l: "english" }
    params[:filters] = filters if filters

    response = @connection.get("api/appdetails", params)
    if response_successful?(response)
      handle_response(response, &block)
    else
      raise "Steam API Error: #{response.status} - #{response.body}"
    end
  end

  def handle_response(response)
    data = response.body[@game_id.to_s]
    if data.is_a?(Hash)
        yield data
    else
        raise "Unexpected data format: #{data.inspect}"
    end
  rescue => e
    Rails.logger.error e.message
    raise
  end

  def process_full_data(game_data)
    {
      game: {
        name: game_data["name"],
        description: game_data["short_description"],
        developer: game_data["developers"]&.first,
        publisher: game_data["publishers"]&.first,
        released_at: game_data["release_date"]["date"]
      },
      genres: game_data["genres"]&.map { |genre| genre["description"] } || [],
      price: game_data.dig("price_overview", "final_formatted"),
      steam_id: @game_id
    }
  end

  def process_price(price_data)
    price_data.dig("price_overview", "final_formatted")
  end

  def response_successful?(response)
    response.body.dig("#{@game_id}", "success") == true
  end
end
