require 'rails_helper'

RSpec.describe GameMarketplace, type: :model do
  describe 'Validations' do
    context 'with valid attributes' do
      let(:game_marketplace) { build(:game_marketplace) }

      it 'is valid' do
        expect(game_marketplace).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'is invalid without a price' do
        game_marketplace = build(:game_marketplace, price: nil)
        expect(game_marketplace).to_not be_valid
        expect(game_marketplace.errors[:price]).to include("can't be blank")
      end
    end
  end

  describe 'Associations' do
    it { should belong_to(:game) }
    it { should belong_to(:marketplace) }
  end
end
