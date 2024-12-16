class GameMarketplace < ApplicationRecord
  belongs_to :game
  belongs_to :marketplace

  validates :price, presence: true
  validates_uniqueness_of :steam_id
end
