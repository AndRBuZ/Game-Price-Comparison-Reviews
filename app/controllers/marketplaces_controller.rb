class MarketplacesController < ApplicationController
  before_action :set_marketplace, only: :show

  def index
    @marketplaces = Marketplace.all
  end

  def show; end

  private

  def set_marketplace
    @marketplace = Marketplace.find(params[:id])
  end
end
