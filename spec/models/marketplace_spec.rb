require 'rails_helper'

RSpec.describe Marketplace, type: :model do
  describe 'Validations' do
    context 'with valid attributes' do
      let(:marketplace) { build(:marketplace) }

      it 'is valid' do
        expect(marketplace).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'is invalid without a name' do
        marketplace = build(:marketplace, name: nil)
        expect(marketplace).to_not be_valid
        expect(marketplace.errors[:name]).to include("can't be blank")
      end

      it 'is invalid without a URL' do
        marketplace = build(:marketplace, url: nil)
        expect(marketplace).to_not be_valid
        expect(marketplace.errors[:url]).to include("can't be blank")
      end

      it 'is invalid with an invalid URL' do
        marketplace = build(:marketplace, url: 'invalid-url')
        expect(marketplace).to_not be_valid
        expect(marketplace.errors[:url]).to include("is not a valid URL")
      end
    end
  end

  describe 'Associations' do
    it { should have_many(:game_marketplaces) }
    it { should have_many(:games).through(:game_marketplaces) }
  end
end
