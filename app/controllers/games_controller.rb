class GamesController < ApplicationController
  before_action :set_game, only: %i[show]

  def index
    @view_type = params[:view_type] || "tile"

    @games = filter_games_by_genre_and_marketplace(Game.all)

    @marketplace_names = fetch_marketplace_names
    @genre_names = fetch_genre_names
  end

  def show
    @reviews = @game.reviews.where.not(id: nil)
    @review = @game.reviews.new
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def fetch_marketplace_names
    Rails.cache.fetch("marketplaces/names", expires_in: 24.hours) do
      Marketplace.pluck(:name)
    end
  end

  def fetch_genre_names
    Rails.cache.fetch("genres/names", expires_in: 24.hours) do
      Genre.pluck(:name)
    end
  end

  def filter_games_by_genre_and_marketplace(games)
    games = games.by_genre(params[:genres]) if params[:genres].present?
    games = games.by_marketplace(params[:marketplaces]) if params[:marketplaces].present?
    games
  end
end
