class GameMarketplace < ApplicationRecord
  belongs_to :game
  belongs_to :marketplace

  validates :price, presence: true
  validates :steam_id, uniqueness: true
  validates :xbox_id, uniqueness: true
end
