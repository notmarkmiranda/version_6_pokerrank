class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user

  def full_name
    user.full_name
  end
end
