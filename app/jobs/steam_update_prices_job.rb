class SteamUpdatePricesJob < ApplicationJob
  queue_as :default

  def perform
    GameMarketplace.pluck(:steam_id).compact.each { |steam_id| SteamApiService.new(steam_id).update_price }
  end
end
