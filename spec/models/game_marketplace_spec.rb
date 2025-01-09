require 'rails_helper'

RSpec.describe GameMarketplace, type: :model do
  describe 'Validations' do
    subject { FactoryBot.build(:game_marketplace) }

    it { should validate_presence_of(:price) }
    it { should validate_uniqueness_of(:steam_id) }
    it { should validate_uniqueness_of(:xbox_id) }
  end

  describe 'Associations' do
    it { should belong_to(:game) }
    it { should belong_to(:marketplace) }
  end
end
