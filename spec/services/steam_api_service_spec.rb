require 'rails_helper'
require 'faraday'

RSpec.describe SteamApiService do
  let(:steam_game_id) { 10000 }
  let(:steam_api_service) { described_class.new(steam_game_id) }
  let!(:marketplace) { create(:marketplace, name: "Steam") }
  let!(:game_marketplace) { create(:game_marketplace, steam_id: steam_game_id, marketplace: marketplace) }

  let(:game_data) do
    {
      "10000" => {
        "success" => true,
        "data" => {
          "name" => "Test Game",
          "short_description" => "A test game",
          "developers" => [ "Test Developer" ],
          "publishers" => [ "Test Publisher" ],
          "release_date" => { "date" => "2023-01-01" },
          "genres" => [
            { "description" => "Action" },
            { "description" => "Adventure" }
          ],
          "price_overview" => { "final_formatted" => "$19.99" }
        }
      }
    }
  end

  before do
    allow(Faraday).to receive(:new).and_return(double(get: double(body: game_data, status: 200)))
  end

  describe '#fetch_game_details' do
    it 'from Steam API and saves them to the database' do
      expect(GameDataSaver).to receive(:new).with(
        {
          game: {
            name: "Test Game",
            description: "A test game",
            developer: "Test Developer",
            publisher: "Test Publisher",
            released_at: "2023-01-01"
          },
          genres: [ "Action", "Adventure" ],
          price: "$19.99",
          steam_id: steam_game_id
        },
        marketplace
      ).and_return(double(process_and_save: true))

      steam_api_service.fetch_game_details
    end
  end

  describe '#update_price' do
    it 'of a game in the database' do
      steam_api_service.update_price
      expect(game_marketplace.reload.price).to eq("$19.99")
    end
  end

  describe '#fetch_data' do
    context 'when the response is successful' do
      it 'yields the data to the block' do
        expect do |block|
          steam_api_service.send(:fetch_data, &block)
        end.to yield_with_args(game_data["10000"])
      end
    end

    context 'when the response is not successful' do
      before do
        allow(Faraday).to receive(:new).and_return(double(get: double(body: { "10000" => { "success" => false } }, status: 404)))
      end

      it 'raises an error' do
        expect { steam_api_service.send(:fetch_data) }.to raise_error(/Steam API Error/)
      end
    end
  end

  describe '#process_full_data' do
    it 'game data and returns a hash' do
      result = steam_api_service.send(:process_full_data, game_data["10000"]["data"])
      expect(result).to eq(
        {
          game: {
            name: "Test Game",
            description: "A test game",
            developer: "Test Developer",
            publisher: "Test Publisher",
            released_at: "2023-01-01"
          },
          genres: [ "Action", "Adventure" ],
          price: "$19.99",
          steam_id: steam_game_id
        }
      )
    end
  end

  describe '#process_price' do
    it 'data and returns the formatted price' do
      price_data = game_data["10000"]["data"]
      expect(steam_api_service.send(:process_price, price_data)).to eq("$19.99")
    end
  end

  describe '#response_successful?' do
    it 'returns true when the response indicates success' do
      expect(steam_api_service.send(:response_successful?, double(body: game_data))).to be true
    end

    it 'returns false when the response indicates failure' do
      failure_data = { "10000" => { "success" => false } }
      expect(steam_api_service.send(:response_successful?, double(body: failure_data))).to be false
    end
  end
end
