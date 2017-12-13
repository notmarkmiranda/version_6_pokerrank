require 'rails_helper'

describe Game, type: :model do
  context 'validations' do
    it { should validate_presence_of :date }
    it { should validate_presence_of :buy_in }
    it { should validate_presence_of :season_id }
    it { should validate_presence_of :attendees }
  end

  context 'relationships' do
    it { should belong_to :season }
    it { should have_many :players }
    it 'should have a league' do
      league = create(:league)
      game = create(:game, season: league.seasons.first)

      expect(game.league).to eq(league)
    end
  end

  context 'methods' do
    let(:game1) { create(:game, completed: false) }

    context '#all_possible_players' do
      let(:admin) { game1.league.creator }
      let(:other_game) { create(:game) }
      let(:other_admin) { other_game.league.creator }

      it 'returns the list of possible, unfinished players' do
        expect(game1.all_possible_players).to include(admin)
        expect(game1.all_possible_players).to_not include(other_admin)
      end
    end

    context '#complete! & #uncomplete!' do
      let(:game2) { create(:game, completed: true) }

      it '#complete! for an incomplete game' do
        game1.complete!
        expect(game1.reload.completed).to be true
      end

      it '#complete! for an already completed game' do
        game2.complete!
        expect(game2.reload.completed).to be true
      end

      it '#uncomplete! for an incomplete game' do
        game1.uncomplete!
        expect(game1.reload.completed).to be false
      end

      it '#uncomplete! for a completed game' do
        game2.uncomplete!
        expect(game2.reload.completed).to be false
      end
    end

    context '#finished_players' do
      let(:player) { create(:player) }
      let(:game) { player.game }
      let!(:other_player) { create(:player, game: game, finishing_place: nil) }

      it 'returns players that are finished' do
        expect(game.finished_players).to include(player)
        expect(game.finished_players).to_not include(other_player)
      end
    end

    context '#full_date' do
      let(:game) { create(:game, date: Date.new(1981, 12, 6)) }

      it 'returns a formatted date' do
        expect(game.full_date).to eq('December 6, 1981')
      end
    end

    context '#incomplete?' do
      let(:game) { create(:game) }

      it 'returns true for an incomplete game' do
        game.uncomplete!
        expect(game.incomplete?).to be true
      end

      it 'returns false for a complete game' do
        game.complete!
        expect(game.incomplete?).to be false
      end
    end
  end
end
