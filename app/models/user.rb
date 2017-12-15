class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: true
  validates :first_name, presence: true, uniqueness: { scope: :last_name }
  validates :last_name, presence: true

  has_many :created_leagues, class_name: 'League', foreign_key: 'user_id'
  has_many :user_league_roles
  has_many :leagues, through: :user_league_roles
  has_many :players

  accepts_nested_attributes_for :user_league_roles

  def admin_for_league?(league)
    admin_leagues.include?(league)
  end

  def admin_leagues
    leagues.merge(UserLeagueRole.admins)
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def invite_user(league)
    ulr = user_league_role_for_league(league)
    return if ulr.invited
    ulr.update(invited: true)
  end

  def is_admin?(league)
    league.admins.include?(self)
  end

  def is_invited?(league)
    user_league_role_for_league(league).invited?
  end

  def member_leagues
    leagues.merge(UserLeagueRole.members)
  end

  private

  def user_league_role_for_league(league)
    UserLeagueRole.find_by(user_id: id, league_id: league.id)
  end

end
