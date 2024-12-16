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

  def fetch_game_details
    response = @connection.get("api/appdetails?appids=#{@game_id}")

    handle_response(response) do |game_data|
      game = save_game(process_data_for_game(game_data["data"]))
      save_genres(process_data_for_genres(game_data["data"]), game)
      save_game_marketplace(game, process_data_for_price(game_data["data"]))
    end
  end

  def update_prices
    response = @connection.get("api/appdetails?appids=#{@game_id}&filters=price_overview")

    handle_response(response) do |price_data|
      game_marketplace = GameMarketplace.find_or_initialize_by(steam_id: @game_id)
      game_marketplace.update!(price: process_data_for_price(price_data["data"]))
    end
  end

  private

  def handle_response(response)
    if response.success?
      data = response.body["#{@game_id}"]
      yield data if data.is_a?(Hash)
    else
      log_errors(response)
    end
  end

  def process_data_for_game(game_data)
    {
      name: game_data["name"],
      description: game_data["short_description"],
      developer: game_data["developers"].first,
      publisher: game_data["publishers"].first,
      released_at: game_data["release_date"]["date"]
    }
  end

  def process_data_for_genres(game_data)
    game_data["genres"].map { |genre| genre["description"] }
  end

  def process_data_for_price(price_data)
    price_data["price_overview"]["final_formatted"]
  end

  def save_game(game_data)
    game = Game.find_or_initialize_by(name: game_data[:name])
    game.update!(game_data)
    game
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to save game: #{game_data[:name]} - #{e.message}"
  end

  def save_genres(genres, game)
    genres.each do |genre_name|
      genre = Genre.find_or_create_by(name: genre_name)
      game.genres << genre unless game.genres.include?(genre)
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to save genre: #{genre_name} - #{e.message}"
  end

  def save_game_marketplace(game, price)
    marketplace = Marketplace.find_by(name: "Steam")
    game.game_marketplaces.create!(marketplace: marketplace, price: price, steam_id: @game_id)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to save price: #{game.name} - #{e.message}"
  end

  def log_errors(response)
    Rails.logger.error "Steam API Error: #{response.status} - #{response.body}"
  end
end
