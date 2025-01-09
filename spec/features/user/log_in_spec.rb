require 'rails_helper'

feature 'User tries to log in' do
  given(:user) { create(:user) }

  before do
    visit login_path
  end

  context 'successfully' do
    scenario 'with valid email and password' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'

      expect(page).to have_content("Logged in successfully")
      expect(page).to have_current_path(root_path)
    end
  end

  context 'unsuccessfully' do
    scenario 'with invalid email' do
      fill_in 'Email', with: 'invalid_email'
      fill_in 'Password', with: 'invalid_password'
      click_button 'Login'

      expect(page).to have_content("Invalid email or password")
      expect(page).to have_current_path(login_path)
    end

    scenario 'with invalid password' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'invalid_password'
      click_button 'Login'

      expect(page).to have_content("Invalid email or password")
      expect(page).to have_current_path(login_path)
    end
  end
end
