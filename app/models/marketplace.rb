class Marketplace < ApplicationRecord
  has_many :game_marketplaces
  has_many :games, through: :game_marketplaces

  validates :name, presence: true
  validates :url, presence: true, format: { with: /\Ahttps?:\/\/[\w\d\-.]+\.[a-z]+\z/i }
end
