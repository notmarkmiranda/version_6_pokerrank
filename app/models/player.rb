class Player < ApplicationRecord
  validates :game_id, presence: true, uniqueness: { scope: :finishing_place }
  belongs_to :game
  belongs_to :user

  def full_name
    user.full_name
  end

  def self.user_ids_by_game(game)
    select(:user_id).where(game_id: game)
  end

  def total_expense
    game.buy_in + additional_expense
  end
end
