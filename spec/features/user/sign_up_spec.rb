require 'rails_helper'

feature 'User tries to sign up' do
  given!(:user) { build(:user) }

  before do
    visit signup_path
  end


  scenario 'successfully' do
    fill_in 'Nickname', with: user.nickname
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'Sign Up'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('User created successfully')
  end

  context 'unsuccessfully' do
    scenario 'with email server side validation', js: true do
      page.execute_script("document.querySelector('form').setAttribute('novalidate', true)")

      fill_in 'Nickname', with: user.nickname
      fill_in 'Email', with: 'invalid_email'
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_button 'Sign Up'

      expect(page).to have_content("Email is invalid")
      expect(page).to have_current_path(signup_path)
    end

    scenario 'with email client side validation', js: true do
      fill_in 'Nickname', with: user.nickname
      fill_in 'Email', with: 'invalid_email'
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password

      validity = page.evaluate_script('document.getElementById("user_email").validity.valid')
      expect(validity).to be false

      validation_message = page.evaluate_script('document.getElementById("user_email").validationMessage')
      expect(validation_message).to be_present
    end

    scenario 'email is already taken', js: true do
      user.save

      within 'form' do
        fill_in 'Nickname', with: user.nickname
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        fill_in 'Password confirmation', with: user.password
        click_button 'Sign Up'
      end

      expect(page).to have_content("Email has already been taken")
      expect(page).to have_current_path(signup_path)
    end
  end

  scenario 'nickname is required', js: true do
    fill_in 'Nickname', with: ''
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'Sign Up'

    expect(page).to have_content("Nickname can't be blank")
    expect(page).to have_current_path(signup_path)
  end


  context 'password' do
    scenario 'is required', js: true do
      fill_in 'Nickname', with: user.nickname
      fill_in 'Email', with: user.email
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: user.password
      click_button 'Sign Up'

      expect(page).to have_content("Password can't be blank")
      expect(page).to have_current_path(signup_path)
    end

    scenario 'confirmation does not match', js: true do
      fill_in 'Nickname', with: user.nickname
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: 'invalid_password'
      click_button 'Sign Up'

      expect(page).to have_content("Password confirmation doesn't match")
      expect(page).to have_current_path(signup_path)
    end
  end
end
