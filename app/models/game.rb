class Game < ApplicationRecord
  has_many :game_marketplaces
  has_many :marketplaces, through: :game_marketplaces

  has_and_belongs_to_many :games_genres, dependent: :destroy

  validates :name, presence: true
end
