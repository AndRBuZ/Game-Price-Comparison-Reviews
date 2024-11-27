require 'rails_helper'

RSpec.describe Marketplace, type: :model do
  it { should have_many(:games).through(:game_marketplaces) }
  it { should have_many(:game_marketplaces) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }
end
