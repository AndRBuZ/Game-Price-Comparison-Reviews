require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe "Associations" do
    it { should have_and_belong_to_many(:games) }
  end
end
