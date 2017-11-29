class Game < ApplicationRecord
  validates :date, presence: true
  validates :buy_in, presence: true
  validates :season_id, presence: true
  validates :attendees, presence: true

  belongs_to :season
  delegate :league, to: :season
end
