require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'Validations' do
    let(:user) { create(:user) }
    let(:game) { create(:game) }
    subject { build(:review, user: user, game: game) }

    it { should validate_presence_of(:body) }
    it 'is valid with unique user_id and game_id combination' do
      expect(existing_review).to be_valid
    end

    it 'is invalid with duplicate user_id and game_id combination' do
      existing_review = create(:review, user: user, game: game)

      duplicate_review = build(:review, user: user, game: game)

      expect(duplicate_review).not_to be_valid
      expect(duplicate_review.errors[:user_id]).to include("You have already reviewed this game")
    end
  end

  describe 'Associations' do
    it { should belong_to(:game) }
    it { should belong_to(:user) }
  end
end
