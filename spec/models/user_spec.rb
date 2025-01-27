require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value('test@example.com').for(:email) }
    it { should_not allow_value('test@example').for(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:nickname) }
  end

  describe 'Associations' do
    it { should have_many(:reviews) }
  end
end
