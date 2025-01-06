require 'rails_helper'

feature 'Users can view a game' do
  given!(:game) { create(:game) }
  given!(:game_marketplace) { create(:game_marketplace, game: game) }

  describe 'successfully' do
    background do
      visit game_path(game)
    end

    scenario 'displays game details' do
      expect(page).to have_content(game.name)
      expect(page).to have_content(game.description)
      expect(page).to have_content(game.developer)
      expect(page).to have_content(game.publisher)
      expect(page).to have_content(game.released_at)
      expect(page).to have_content(game_marketplace.price)
    end
  end

  describe 'unsuccessfully' do
    scenario 'displays error message' do
      visit game_path(999)

      expect(page).to have_content("Couldn't find Game")
    end
  end
end
