class User < ApplicationRecord
  EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/.freeze

  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  validates :nickname, presence: true
end
