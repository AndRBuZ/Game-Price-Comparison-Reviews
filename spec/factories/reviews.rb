FactoryBot.define do
  factory :review do
    game
    user
    body { 'Great game!' }
  end
end
