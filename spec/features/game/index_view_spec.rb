require 'rails_helper'

feature 'Users can view a list of games' do
  given!(:game) { create_list(:game, 3) }

  describe 'successfully' do
    before { visit root_path(view_type: "list") }

    scenario 'view type is list' do
      expect(page).to have_content(game.first.name)
      expect(page).to have_content(game.second.name)
      expect(page).to have_content(game.third.name)
    end

    scenario 'view type is tile' do
      expect(page).to have_content(game.first.name)
      expect(page).to have_content(game.second.name)
      expect(page).to have_content(game.third.name)
    end
  end
end
