require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'Validations' do
    subject { FactoryBot.build(:game) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'Associations' do
    it { should have_many(:game_marketplaces).dependent(:destroy) }
    it { should have_many(:marketplaces).through(:game_marketplaces) }
    it { should have_and_belong_to_many(:genres).dependent(:destroy) }
  end
end
