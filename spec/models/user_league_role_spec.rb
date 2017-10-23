require 'rails_helper'

describe UserLeagueRole, type: :model do
  context 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:league_id) }
    it { should validate_presence_of(:role) }
    it do
      create(:user_league_role, :regular_user)
      should validate_uniqueness_of(:user_id).scoped_to(:league_id, :role)
    end
  end

  context 'relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:league) }
  end
end
