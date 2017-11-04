class Season < ApplicationRecord
  validates :league_id, presence: true
  validates :active, presence: true

  belongs_to :league

  after_create_commit :deactivate_other_seasons

  private

  def deactivate_other_seasons
    league.seasons.where.not(id: self).update_all(active: false)
  end
end
