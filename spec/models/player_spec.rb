require 'rails_helper'

describe Player, type: :model do
  context 'validations'
  context 'relationships' do
    it { should belong_to :game }
    it { should belong_to :user }
  end

  context 'methods' do
    it 'returns the players full name' do
      user = create(:user, first_name: 'Mark', last_name: 'Miranda')
      player = create(:player, user: user)

      expect(player.full_name).to eq('Mark Miranda')
    end
  end
end
