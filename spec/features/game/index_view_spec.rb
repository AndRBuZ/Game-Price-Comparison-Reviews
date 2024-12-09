require 'rails_helper'

feature 'Users can view a list of games' do
  given!(:game) { create_list(:game, 3) }

  scenario 'successfully' do
    visit root_path

    expect(page).to have_content(game.first.name)
    expect(page).to have_content(game.second.name)
    expect(page).to have_content(game.third.name)
  end
end
