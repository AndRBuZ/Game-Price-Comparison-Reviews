class XboxApiService
  BASE_URL = "https://displaycatalog.mp.microsoft.com/".freeze

  def initialize(game_id)
    @game_id = game_id
    @connection = Faraday.new(url: BASE_URL) do |faraday|
      faraday.request :url_encoded
      faraday.response :json
      faraday.adapter Faraday.default_adapter
    end
  end

  def fetch_game_details
    marketplace = Marketplace.find_by(name: "Xbox")
    fetch_data do |data|
      game_data = process_full_data(data)
      GameDataSaver.new(game_data, marketplace).process_and_save
    end
  end

  def update_price
    fetch_data do |data|
      price = process_price(data)
      game_marketplace = GameMarketplace.find_by(xbox_id: @game_id)
      game_marketplace.update!(price: price)
    end
  end

  private

  def fetch_data(filters: nil, &block)
    params = { bigIds: @game_id, market: "US", languages: "en-us" }

    response = @connection.get("v7.0/products", params)

    if response_successful?(response)
      handle_response(response, &block)
    else
      raise "Xbox API Error: #{response.status} - #{response.body}"
    end
  end

  def handle_response(response)
    data = response.body["Products"]

    if data.is_a?(Array)
      yield data.first
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
        name: game_data["LocalizedProperties"].first["ProductTitle"],
        description: game_data["LocalizedProperties"].first["ProductDescription"].gsub("\n", ""),
        developer: game_data["LocalizedProperties"].first["DeveloperName"],
        publisher: game_data["LocalizedProperties"].first["PublisherName"],
        released_at: game_data["MarketProperties"].first["OriginalReleaseDate"]
      },
      genres: game_data["Properties"]["Categories"].map { |genre| genre },
      price: game_data["DisplaySkuAvailabilities"].first["Availabilities"].first["OrderManagementData"]["Price"]["ListPrice"].to_s + " $",
      xbox_id: @game_id
    }
  end

  def process_price(price_data)
    price_data["DisplaySkuAvailabilities"].first["Availabilities"].first["OrderManagementData"]["Price"]["ListPrice"].to_s + " $"
  end

  def response_successful?(response)
    response.status == 200 && response.body["Products"].present?
  end
end
