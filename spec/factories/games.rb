FactoryBot.define do
  factory :game do
    sequence(:name) { |n| "game_#{n}" }
  end
end
