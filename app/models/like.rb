class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates :reaction, presence: true

  validate :validate_author_cant_like

  enum :reaction, { like: 1, dislike: -1 }

  private

  def validate_author_cant_like
    errors.add(:user, "Author can't like their own content") if user&.author_of?(likeable)
  end
end
