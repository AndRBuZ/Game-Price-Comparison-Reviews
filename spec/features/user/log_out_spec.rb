require 'rails_helper'

feature 'User tries to logout' do
  given(:user) { create(:user) }

  before do
    log_in(user)
  end

  scenario 'successfully' do
    click_on 'Logout'

    expect(page).to have_content("Logged out successfully")
    expect(page).to have_current_path(root_path)
  end
end
