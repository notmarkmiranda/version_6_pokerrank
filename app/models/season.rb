class Season < ApplicationRecord
  validates :league_id, presence: true

  belongs_to :league
  has_many :games

  after_create_commit :deactivate_other_seasons

  private

  def deactivate_other_seasons
    league.seasons.where.not(id: self.id).update_all(active: false)
  end
end
