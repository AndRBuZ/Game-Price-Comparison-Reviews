require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'Validations' do
    context 'with valid attributes' do
      let(:genre) { build(:genre) }

      it 'is valid' do
        expect(genre).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'is invalid without a name' do
        genre = build(:genre, name: nil)
        expect(genre).to_not be_valid
        expect(genre.errors[:name]).to include("can't be blank")
      end
    end
  end

  describe "Associations" do
    it { should have_and_belong_to_many(:games) }
  end
end
