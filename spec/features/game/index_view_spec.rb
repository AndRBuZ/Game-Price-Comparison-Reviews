require 'rails_helper'

feature 'Users can view a list of games' do
  given!(:genre_1) { create(:genre, name: "RPG") }
  given!(:genre_2) { create(:genre, name: "Adventure") }

  given!(:marketplace_1) { create(:marketplace) }
  given!(:marketplace_2) { create(:marketplace, name: "Marketplace 2", url: "https://marketplace2.com") }

  given!(:games) { create_list(:game, 3) }

  given!(:game_marketplace_1) { create(:game_marketplace, game: games.first, marketplace: marketplace_1) }
  given!(:game_marketplace_2) { create(:game_marketplace, game: games.second, marketplace: marketplace_2) }

  before do
    games.first.genres << genre_1
    games.second.genres << genre_2
  end

  describe 'successfully' do
    before { visit root_path(view_type: "list") }

    describe 'view type' do
      scenario 'view type is list' do
        expect(page).to have_content(games.first.name)
        expect(page).to have_content(games.second.name)
        expect(page).to have_content(games.third.name)
      end

      scenario 'view type is tile', js: true do
        find('select#view-type option[value="tile"]').click

        expect(page).to have_content(games.first.name)
        expect(page).to have_content(games.second.name)
        expect(page).to have_content(games.third.name)
      end
    end

    describe 'filter', js: true do
      scenario "User opens and closes the filter menu", js: true do
        expect(page).to have_selector('#filter-menu', visible: :hidden)

        find('#filter-toggle').click
        expect(page).to have_selector('#filter-menu', visible: :visible)

        find('#filter-toggle').click
        expect(page).to have_selector('#filter-menu', visible: :hidden)
      end

      scenario 'use genre filter' do
        find('#filter-toggle').click
        find('#genre-toggle').click
        find("input[value='RPG']").check

        click_button 'Apply filters'

        expect(page).to have_content(games.select { |game| game.genres.include?(genre_1) }.first.name)
        expect(page).not_to have_content(games.select { |game| game.genres.include?(genre_2) }.first.name)
      end

      scenario 'use marketplace filter' do
        find('#filter-toggle').click
        find('#marketplace-toggle').click
        find("input[value='Steam']").check

        click_button 'Apply filters'

        expect(page).to have_content(games.select { |game| game.marketplaces.include?(marketplace_1) }.first.name)
        expect(page).not_to have_content(games.select { |game| game.marketplaces.include?(marketplace_2) }.first.name)
      end

      scenario 'use both genre and marketplace filters' do
        find('#filter-toggle').click
        find('#genre-toggle').click
        find("input[value='Adventure']").check
        find('#marketplace-toggle').click
        find("input[value='Marketplace 2']").check

        click_button 'Apply filters'

        expect(page).to have_content(games.select { |game| game.genres.include?(genre_2) && game.marketplaces.include?(marketplace_2) }.first.name)
      end
    end
  end
end
