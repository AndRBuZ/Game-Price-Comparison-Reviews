module FeatureHelpers
  def log_in(user)
    visit login_path
    within 'form' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Login'
    end
  end

  def log_out
    accept_confirm do
      click_on 'Logout'
    end

    expect(page).to have_content("Logged out successfully", wait: 5)
  end
end
