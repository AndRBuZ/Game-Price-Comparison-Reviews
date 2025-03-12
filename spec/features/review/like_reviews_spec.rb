require 'rails_helper'

feature 'User likes a review' do
  given(:game) { create(:game) }
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:review) { create(:review, game: game, user: user) }

  describe 'user is author of review' do
    before do
      log_in(user)
      expect(page).to have_content('Logged in successfully')
      visit game_path(game)
    end

    scenario 'does not like own review' do
      within "turbo-frame[id='review-#{review.id}']" do
        expect(page).to_not have_content('like')
        expect(page).to_not have_content('dislike')
      end
    end
  end

  describe 'user is not author of review', js: true do
    before do
      log_in(user2)
      expect(page).to have_content('Logged in successfully')
      visit game_path(game)
    end

    scenario 'can like review' do
      within "turbo-frame[id='review-#{review.id}']" do
        expect(page).to have_content('like')
        expect(page).to have_content('dislike')

        click_on 'like'

        expect(page).to have_content('1')
      end
    end

    scenario 'can dislike review' do
      within "turbo-frame[id='review-#{review.id}']" do
        expect(page).to have_content('like')
        expect(page).to have_content('dislike')

        click_on 'dislike'

        expect(page).to have_content('-1')
      end
    end
  end

  describe 'user is not logged in' do
    before do
      visit game_path(game)
    end

    scenario 'cannot like review' do
      within "turbo-frame[id='review-#{review.id}']" do
        expect(page).to have_content('like')
        expect(page).to have_content('dislike')

        click_on 'like'

        expect(page).to have_current_path(login_path)
      end
    end
  end
end
