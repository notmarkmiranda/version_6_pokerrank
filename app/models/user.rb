class User < ApplicationRecord
  has_secure_password
  # validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true, uniqueness: { scope: :last_name }
  validates :last_name, presence: true

  has_many :leagues
  has_many :user_league_roles
end
