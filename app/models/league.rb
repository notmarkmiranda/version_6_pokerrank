class League < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true
  validates :user_id, presence: true

  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_many :user_league_roles
  has_many :users, through: :user_league_roles
  has_many :seasons

  before_validation :set_slug
  after_create :create_admin_league_role
  after_create :create_initial_season

  def active_season
    # seasons.where(active: true).first
  end

  def admins
    users.merge(UserLeagueRole.admins)
  end

  def grant_membership(user)
    add_person(user, 0)
  end

  def grant_admin(user)
    add_person(user, 1)
  end

  def members
    users.merge(UserLeagueRole.members)
  end

  def self.find(slug)
    find_by_slug(slug)
  end

  def to_param
    self.slug if slug
  end

  private

  def add_person(user, role_type)
    return if already_part_of_league_in_role?(user, role_type)
    roles = user_league_roles.where(user_id: user.id)
    roles.destroy_all
    roles.create!(user_id: user.id, role: role_type)
  end

  def already_part_of_league_in_role?(user, role_type)
    if role_type.zero?
      members.include?(user)
    else
      admins.include?(user)
    end
  end

  def create_admin_league_role
    user_league_roles.create!(role: 1, user_id: creator.id)
  end

  def create_initial_season
    seasons.create(active: true)
  end

  def find_by_slug(slug)
    find_by(slug: slug)
  end

  def set_slug
    self.slug = name.parameterize if should_change_slug?
  end

  def should_change_slug?
    !name.blank?
  end
end
