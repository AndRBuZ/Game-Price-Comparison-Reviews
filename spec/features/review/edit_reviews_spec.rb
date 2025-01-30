require 'rails_helper'

feature 'User edits a review' do
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

    scenario 'with valid review' do
      within "turbo-frame[id='review-#{review.id}']" do
        click_on 'Edit'
      end

      within "turbo-frame[id='edit-review-#{review.id}']" do
        fill_in 'Body', with: 'Great game2!'
        click_button 'Submit'
      end

      expect(page).to have_content('Great game2!')
      expect(page).to have_content(user.nickname)
    end

    scenario 'with invalid review' do
      within "turbo-frame[id='review-#{review.id}']" do
        click_on 'Edit'
      end

      within "turbo-frame[id='edit-review-#{review.id}']" do
        fill_in 'Body', with: ''
        click_button 'Submit'
      end

      expect(page).to have_content("Body can't be blank")
    end
  end

  scenario 'user is not author of review' do
    log_in(user2)
    visit game_path(game)

    expect(page).to_not have_content('Edit')
  end

  scenario 'user is not logged in' do
    visit game_path(game)

    expect(page).to_not have_content('Edit')
  end
end
