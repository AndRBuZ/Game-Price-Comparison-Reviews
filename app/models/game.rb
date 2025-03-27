class Game < ApplicationRecord
  has_many :game_marketplaces, dependent: :destroy
  has_many :marketplaces, through: :game_marketplaces
  has_many :reviews, dependent: :destroy

  has_and_belongs_to_many :genres, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :by_marketplace, ->(marketplaces) { joins(game_marketplaces: :marketplace).where(marketplaces: { name: marketplaces }) }
  scope :by_genre, ->(genres) { joins(:genres).where(genres: { name: genres }) }
end
