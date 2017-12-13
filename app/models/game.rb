class Game < ApplicationRecord
  validates :date, presence: true
  validates :buy_in, presence: true
  validates :season_id, presence: true
  validates :attendees, presence: true

  belongs_to :season
  has_many :players
  delegate :league, to: :season

  after_update_commit :score_game

  def all_possible_players
    league.users.where.not(id: Player.user_ids_by_game(self))
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

  def players_count
    players.count
  end

  def uncomplete!
    update(completed: false)
  end

  private

  def score_game
    players.each do |player|
      player.update(score: score_player(player))
    end
  end

  def score_player(player)
    numerator = players_count * buy_in ** 2 / player.total_expense
    denominator = player.finishing_place + 1
    ((Math.sqrt(numerator) / denominator) * 100).floor / 100.0
  end
end
