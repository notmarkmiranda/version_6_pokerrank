class Game < ApplicationRecord
  validates :date, presence: true
  validates :buy_in, presence: true
  validates :season_id, presence: true
  validates :attendees, presence: true

  belongs_to :season
  delegate :league, to: :season

  def complete!
    update(completed: true)
  end

  def full_date
    date.strftime('%B %-e, %Y')
  end

  def incomplete?
    !completed?
  end

  def uncomplete!
    update(completed: false)
  end
end
