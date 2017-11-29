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
    it 'should have a league' do
      league = create(:league)
      game = create(:game, season: league.seasons.first)

      expect(game.league).to eq(league)
    end
  end

  context 'methods'
end
