require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'Validations' do
    let(:author) { create(:user) }
    let(:other_user) { create(:user) }
    let(:review) { create(:review, user: author) }

    subject { Like.create!(user: other_user, likeable: review, reaction: :like) }

    it { should validate_presence_of(:reaction) }

    context 'when user is the author' do
      let(:author_like) { Like.new(user: author, likeable: review, reaction: :like) }

      it 'prevents author from liking' do
        author_like.valid?

        expect(author_like).to be_invalid
        expect(author_like.errors[:user]).to include("Author can't like their own content")
      end
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:likeable) }
  end
end
