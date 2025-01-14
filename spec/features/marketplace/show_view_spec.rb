require "rails_helper"

feature "User visits the marketplace show page" do
  given!(:marketplace) { create(:marketplace, name: "Marketplace 1", url: "https://marketplace1.com") }

  describe "successfully" do
    before do
      visit marketplace_path(marketplace)
    end

    scenario "displays the marketplace details" do
      expect(page).to have_content(marketplace.name)
      expect(page).to have_content(marketplace.url)
    end
  end

  describe "unsuccessfully" do
    scenario "with invalid id" do
      visit marketplace_path(999)

      expect(page).to have_content("Marketplace not found")
    end
  end
end
