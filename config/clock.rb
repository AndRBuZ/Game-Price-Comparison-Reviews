require "clockwork"
include Clockwork
require "./config/environment"

handler do |job|
  puts "Running #{job}"
end

every(1.day, "SteamUpdatePricesJob.perform_now", at: "01:00") do
  SteamUpdatePricesJob.perform_now
end
