require 'rails_helper'

feature 'Users can add reviews', js: true do
  given(:game) { create(:game) }
  given(:user) { create(:user) }

  before do
    log_in(user)
    visit game_path(game)
  end

  describe 'successfully' do
    scenario 'with valid review' do
      fill_in 'Body', with: 'Great game!'
      click_button 'Submit'

      expect(page).to have_content('Great game!')
      expect(page).to have_content(user.nickname)
      expect(page).to have_current_path(game_path(game))
    end
  end

  describe 'unsuccessfully' do
    scenario 'with invalid review' do
      fill_in 'Body', with: ''
      click_button 'Submit'

      expect(page).to have_content("Body can't be blank")
    end

    scenario 'user is not logged in' do
      log_out

      visit game_path(game)

      fill_in 'Body', with: 'Great game!'
      click_button 'Submit'

      expect(page).to have_content('You must be logged in to perform that action')
      expect(page).to have_current_path(login_path)
    end

    scenario 'user already reviewed the game' do
      create(:review, user: user, game: game)

      fill_in 'Body', with: 'Great game!'
      click_button 'Submit'

      expect(page).to have_content('You have already reviewed this game')
      expect(page).to have_current_path(game_path(game))
    end
  end
end
