require "rails_helper"

feature "User visits the marketplace index page" do
  given!(:marketplace1) { create(:marketplace, name: "Marketplace 1", url: "https://marketplace1.com") }
  given!(:marketplace2) { create(:marketplace, name: "Marketplace 2", url: "https://marketplace2.com") }
  given!(:marketplace3) { create(:marketplace, name: "Marketplace 3", url: "https://marketplace3.com") }


  scenario "successfully" do
    visit marketplaces_path

    expect(page).to have_content(marketplace1.name)
    expect(page).to have_content(marketplace2.name)
    expect(page).to have_content(marketplace3.name)
  end
end
