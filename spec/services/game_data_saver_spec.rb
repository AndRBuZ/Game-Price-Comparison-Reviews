require 'rails_helper'

RSpec.describe GameDataSaver do
  let(:marketplace) { create(:marketplace) }
  let(:game_data) { generate_game_data }
  let(:game_data_saver) { described_class.new(game_data, marketplace) }

  def generate_game_data(overrides = {})
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
      steam_id: 10000
    }.merge(overrides)
  end

  describe '#process_and_save' do
    context 'when the game data is valid' do
      it 'saves the game data to the database' do
        expect { game_data_saver.process_and_save }.to change(Game, :count).by(1)
        .and change(Genre, :count).by(2)
        .and change(GameMarketplace, :count).by(1)

        game = Game.find_by(name: game_data[:game][:name])
        expect(game).not_to be_nil
        expect(game.description).to eq(game_data[:game][:description])

        expect(game.genres.pluck(:name)).to match_array(game_data[:genres])

        game_marketplace = GameMarketplace.find_by(steam_id: game_data[:steam_id])
        expect(game_marketplace).not_to be_nil
        expect(game_marketplace.price).to eq(game_data[:price])
        expect(game_marketplace.marketplace).to eq(marketplace)
      end
    end

    context 'when the game data is invalid' do
      context "game saving fails" do
        let(:game_data) { generate_game_data(game: { name: nil }) }

        it 'raises and logs an error message' do
          expect(Rails.logger).to receive(:error).with("Failed to save game: Validation failed: Name can't be blank")
          expect { game_data_saver.process_and_save }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context 'genre saving fails' do
        let(:game_data) { generate_game_data(genres: [ nil ]) }

        it 'raises and logs an error message' do
          expect(Rails.logger).to receive(:error).with("Failed to save genres: Validation failed: Name can't be blank")
          expect { game_data_saver.process_and_save }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context 'game marketplace saving fails' do
        let(:game_data) { generate_game_data(steam_id: "invalid") }

        it 'raises and logs an error message' do
          expect(Rails.logger).to receive(:error).with("Failed to save game marketplace: Validation failed: Steam is not a number")
          expect { game_data_saver.process_and_save }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context "when the game data is duplicate" do
      let!(:existing_game) do
        Game.create!(
          name: "Test Game",
          description: "A test game with duplicate important data",
          developer: "Test Developer",
          publisher: "Test Publisher",
          released_at: "2023-01-01"
        )
      end

      let!(:existing_genres) do
        [
          Genre.create!(name: "Action"),
          Genre.create!(name: "Adventure")
        ]
      end

      let!(:existing_game_marketplace) do
        existing_game.game_marketplaces.create!(
          marketplace: marketplace,
          price: "$14.99",
          steam_id: 10000
        )
      end

      it 'does not create duplicates but updates existing records' do
        expect { game_data_saver.process_and_save }.not_to change(Game, :count)
        expect { game_data_saver.process_and_save }.not_to change(Genre, :count)
        expect { game_data_saver.process_and_save }.not_to change(GameMarketplace, :count)

        game = Game.find_by(name: "Test Game")
        expect(game.description).to eq(game_data[:game][:description])

        game_marketplace = GameMarketplace.find_by(steam_id: 10000)
        expect(game_marketplace.price).to eq(game_data[:price])
      end
    end
  end
end
