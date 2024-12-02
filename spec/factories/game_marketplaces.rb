FactoryBot.define do
  factory :game_marketplace do
    game { association :game }
    marketplace { association :marketplace }

    price { 14.99 }
  end
end
