class GamesController < ApplicationController
  before_action :set_game, only: %i[show]

  def index
    @view_type = params[:view_type] || "tile"
    @games = Game.all
  end

  def show; end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
