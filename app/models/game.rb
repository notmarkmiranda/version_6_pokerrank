class Game < ApplicationRecord
  validates :date, presence: true
  validates :buy_in, presence: true
  validates :season_id, presence: true
  validates :attendees, presence: true

  belongs_to :season
  has_many :players
  delegate :league, to: :season

  def all_possible_players
    league.users.where.not(id: Player.select(:user_id).where(game_id: id))
  end

  def complete!
    update(completed: true)
  end

  def finished_players
    players.where.not(finishing_place: nil)
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
