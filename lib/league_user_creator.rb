class LeagueUserCreator
  attr_reader :user, :league, :invited, :admin

  def initialize(user:, league:, user_league_role:)
    @user = user
    @league = league
    @user_league_role = user_league_role
    @invited = user_league_role[:invited].to_i
    @admin = user_league_role[:admin].to_i
  end

  def save
    user.password = SecureRandom.hex(10)
    if user.save
      league.grant_admin(user) if admin?
      league.grant_membership(user)
      user.invite_user(league) if invited?
      return true
    end
    return false
  end

  private

  def admin?
    admin == 1
  end

  def invited?
    invited == 1
  end
end
