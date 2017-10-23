class UserLeagueRole < ApplicationRecord
  validates :user_id, presence: true, uniqueness: { scope: [:league_id, :role] }
  validates :league_id, presence: true
  validates :role, presence: true

  belongs_to :user
  belongs_to :league

  scope :members, -> { where(role: '0') }
  scope :admins, -> { where(role: '1') }
end
