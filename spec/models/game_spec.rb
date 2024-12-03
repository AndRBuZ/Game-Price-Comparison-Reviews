require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'Validations' do
    context 'with valid attributes' do
      let(:game) { build(:game) }

      it 'is valid' do
        expect(game).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'is invalid without a name' do
        game = build(:game, name: nil)
        expect(game).to_not be_valid
        expect(game.errors[:name]).to include("can't be blank")
      end
    end
  end

  describe 'Associations' do
    it { should have_many(:game_marketplaces).dependent(:destroy) }
    it { should have_many(:marketplaces).through(:game_marketplaces) }
    it { should have_and_belong_to_many(:genres).dependent(:destroy) }
  end
end
