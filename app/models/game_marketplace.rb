class GameMarketplace < ApplicationRecord
  belongs_to :game
  belongs_to :marketplace

  validates :price, presence: true
end
