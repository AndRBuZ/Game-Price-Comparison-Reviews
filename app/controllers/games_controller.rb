class GamesController < ApplicationController
  before_action :set_game, only: %i[show]

  def index
    @view_type = params[:view_type] || "tile"
    @games = Game.all
  end

  def show
    @reviews = @game.reviews.where.not(id: nil)
    @review = @game.reviews.new
  end

  private

  def set_game
    @game = Game.includes(:reviews).find(params[:id])
  end
end
