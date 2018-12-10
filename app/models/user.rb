class User < ApplicationRecord
  before_save{email.downcase!}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: true,
    length: {maximum: Settings.valid.length.name.maximum}
  validates :email, presence: true,
    length: {maximum: Settings.valid.length.email.maximum},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.valid.length.password.minimum}

  # Returns the hash digest of the given string.
  def self.digest string
    min_cost = ActiveModel::SecurePassword.min_cost
    cost = min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
