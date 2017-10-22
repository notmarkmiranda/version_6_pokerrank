class UserLeagueRole < ApplicationRecord
  validates :user_id, presence: true, uniqueness: { scope: [:league_id, :role] }
  validates :league_id, presence: true
  validates :role, presence: true

  belongs_to :user
  belongs_to :league
end
