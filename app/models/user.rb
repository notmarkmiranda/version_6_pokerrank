class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: true
  validates :first_name, presence: true, uniqueness: { scope: :last_name }
  validates :last_name, presence: true

  has_many :created_leagues, class_name: 'League', foreign_key: 'user_id'
  has_many :user_league_roles
  has_many :leagues, through: :user_league_roles
  has_many :players

  def admin_leagues
    leagues.merge(UserLeagueRole.admins)
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def member_leagues
    leagues.merge(UserLeagueRole.members)
  end

end
