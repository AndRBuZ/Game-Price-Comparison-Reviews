class Review < ApplicationRecord
  include Likeable

  default_scope { order(created_at: :desc) }

  belongs_to :game
  belongs_to :user

  validates :body, presence: true
  validates :user_id, uniqueness: { scope: :game_id, message: "You have already reviewed this game" }
end
