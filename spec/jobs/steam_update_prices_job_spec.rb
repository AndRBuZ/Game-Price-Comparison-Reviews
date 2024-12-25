require 'rails_helper'

RSpec.describe SteamUpdatePricesJob, type: :job do
  let(:steam_ids) { [ 1001, 1002, 1003 ] }

  before do
    allow(GameMarketplace).to receive(:pluck).with(:steam_id).and_return(steam_ids)

    steam_ids.each do |steam_id|
      steam_service = instance_double(SteamApiService, update_price: true)
      allow(SteamApiService).to receive(:new).with(steam_id).and_return(steam_service)
    end
  end

  describe "#perform_now" do
    it "fetches steam IDs from GameMarketplace" do
      expect(GameMarketplace).to receive(:pluck).with(:steam_id)
      described_class.perform_now
    end

    it "calls SteamApiService#update_price for each steam_id" do
      steam_ids.each do |steam_id|
        steam_service = SteamApiService.new(steam_id)
        expect(steam_service).to receive(:update_price)
      end

      described_class.perform_now
    end
  end
end
