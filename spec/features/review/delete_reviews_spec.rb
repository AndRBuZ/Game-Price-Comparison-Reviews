require 'rails_helper'

feature 'User deletes a review' do
  given(:game) { create(:game) }
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:review) { create(:review, game: game, user: user) }

  describe 'user is author of review', js: true do
    before do
      log_in(user)
      expect(page).to have_content('Logged in successfully')
      visit game_path(game)
    end

    scenario 'successfully' do
      expect(page).to have_content('Great game!')

      within "turbo-frame[id='review-#{review.id}']" do
        accept_confirm do
          click_on 'Delete'
        end
      end

      expect(page).not_to have_content('Great game!')
    end
  end

  scenario 'user is not author of review' do
    log_in(user2)
    visit game_path(game)

    expect(page).not_to have_content('Delete')
  end

  scenario 'user is not logged in' do
    visit game_path(game)

    expect(page).not_to have_content('Delete')
  end
end
