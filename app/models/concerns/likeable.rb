module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likeable, dependent: :destroy
  end

  def likes_count
    likes.sum(:reaction)
  end
end
