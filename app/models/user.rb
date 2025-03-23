class User < ApplicationRecord
  EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/.freeze

  has_many :reviews, dependent: :destroy

  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  validates :nickname, presence: true

  def author_of?(object)
    self.id == object.user_id
  end

  def self.from_omniauth(access_token)
    OauthAuthorization.new(access_token).call
  end
end
