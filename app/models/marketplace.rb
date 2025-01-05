class Marketplace < ApplicationRecord
  has_many :game_marketplaces
  has_many :games, through: :game_marketplaces

  validates :name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true, url: true
end
