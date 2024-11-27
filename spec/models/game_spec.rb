require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should have_many(:marketplaces).through(:game_marketplaces) }
  it { should have_many(:game_marketplaces) }

  it { should has_and_belongs_to_many(:games_genres).dependent(:destroy) }

  it { should validate_presence_of(:name) }
end
