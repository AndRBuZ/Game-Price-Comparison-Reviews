require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'Validations' do
    subject { Genre.new(name: "Action") }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe "Associations" do
    it { should have_and_belong_to_many(:games) }
  end
end
