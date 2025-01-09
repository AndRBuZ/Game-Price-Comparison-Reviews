require 'rails_helper'
require 'faraday'

RSpec.describe XboxApiService do
  let(:xbox_game_id) { "12DSFS7DF09T" }
  let(:xbox_api_service) { described_class.new(xbox_game_id) }
  let!(:marketplace) { create(:marketplace, name: "Xbox") }
  let!(:game_marketplace) { create(:game_marketplace, xbox_id: xbox_game_id, marketplace: marketplace) }

  let(:game_data) do
    {
      "Products" => [
        {
          "LocalizedProperties" => [
            {
              "ProductTitle" => "Test Game",
              "ProductDescription" => "A test game",
              "DeveloperName" => "Test Developer",
              "PublisherName" => "Test Publisher"
            }
          ],
          "MarketProperties" => [
            {
              "OriginalReleaseDate" => "2023-01-01"
            }
          ],
          "Properties" => {
            "Categories" => [ "Action", "Adventure" ]
          },
          "DisplaySkuAvailabilities" => [
            {
              "Availabilities" => [
                {
                  "OrderManagementData" => {
                    "Price" => {
                      "ListPrice" => 19.99
                    }
                  }
                }
              ]
            }
          ]
        }
      ]
    }
  end

  describe '#fetch_game_details' do
    context 'when the API response is successful' do
      before do
        allow(Faraday).to receive(:new).and_return(double(get: double(body: game_data, status: 200)))
      end

      it 'saves them to the database' do
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
            price: "19.99 $",
            xbox_id: xbox_game_id
          },
          marketplace
        ).and_return(double(process_and_save: true))

        xbox_api_service.fetch_game_details
      end
    end

    context 'when the API response is not successful' do
      before do
        allow(Faraday).to receive(:new).and_return(double(get: double(body: game_data, status: 400)))
      end

      it 'raises an error' do
        expect { xbox_api_service.fetch_game_details }.to raise_error(RuntimeError)
      end
    end

    context 'when response data is in an unexpected format' do
      let(:invalid_data) { { "InvalidKey" => [] } }
      let(:response) { double(body: invalid_data, status: 200) }

      it 'raises an error' do
        expect { xbox_api_service.send(:handle_response, response) }
          .to raise_error(RuntimeError, /Unexpected data format/)
      end
    end
  end

  describe '#update_price' do
    context 'when the API response is successful' do
      before do
        allow(Faraday).to receive(:new).and_return(double(get: double(body: game_data, status: 200)))
      end

      it 'of a game in the database' do
        xbox_api_service.update_price
        expect(game_marketplace.reload.price).to eq("19.99 $")
      end
    end

    context 'when the API response is not successful' do
      before do
        allow(Faraday).to receive(:new).and_return(double(get: double(body: game_data, status: 400)))
      end

      it 'raises an error' do
        expect { xbox_api_service.update_price }.to raise_error(RuntimeError)
      end
    end
  end
end
