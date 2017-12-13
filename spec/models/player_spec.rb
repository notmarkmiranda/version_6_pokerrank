require 'rails_helper'

describe Player, type: :model do
  context 'validations' do
    it { should validate_presence_of :game_id }
    it 'validates uniqueness of game and finishing place' do
      create(:player)
      should validate_uniqueness_of(:game_id).scoped_to(:finishing_place)
    end
  end

  context 'relationships' do
    it { should belong_to :game }
    it { should belong_to :user }
  end

  context 'methods' do
    let(:user) { create(:user, first_name: 'Mark', last_name: 'Miranda') }
    let(:player) { create(:player, user: user) }

    context '#full_name' do
      it 'returns the players full name' do
        expect(player.full_name).to eq('Mark Miranda')
      end
    end

    context 'self#user_ids_by_game' do
      let(:game) { player.game }
      it 'returns player objects from a game' do
        player = Player.user_ids_by_game(game).first
        expect(player).to have_attributes(:user_id => user.id)
      end
    end

    context '#total_expense' do
      it 'returns the total expense for a player' do
        player.game.update(buy_in: 100)
        player.update(additional_expense: 100)
        expect(player.total_expense).to eq(200)
      end
    end
  end
end
