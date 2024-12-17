require 'rails_helper'

RSpec.describe Marketplace, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:url) }
    it { is_expected.to validate_url_of(:url) }
  end

  describe 'Associations' do
    it { should have_many(:game_marketplaces) }
    it { should have_many(:games).through(:game_marketplaces) }
  end
end
