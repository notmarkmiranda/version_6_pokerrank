class League < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true
  validates :user_id, presence: true

  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_many :user_league_roles
  before_validation :set_slug

  def self.find(slug)
    find_by_slug(slug)
  end

  def to_param
    self.slug if slug
  end

  private

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
