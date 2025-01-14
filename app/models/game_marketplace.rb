class GameMarketplace < ApplicationRecord
  belongs_to :game
  belongs_to :marketplace

  validates :price, presence: true
  validates :steam_id, uniqueness: true, allow_nil: true
  validates :xbox_id, uniqueness: true, allow_nil: true
end
