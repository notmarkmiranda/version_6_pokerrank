require 'rails_helper'

describe League, type: :model do
  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :slug }
    it { should validate_presence_of :user_id }
  end

  context 'relationships' do
    it { should belong_to :creator }
    it { should have_many :user_league_roles }
  end

  context 'methods' do
    context '#find' do
      before do
        @league = create(:league, name: 'marks league')
      end

      it 'finds a league' do
        expect(League.find('marks-league')).to eq(@league)
      end

      it 'returns nil with no league' do
        expect(League.find('not-marks-league')).to be nil
      end
    end

    context '#to_param' do
      before do
        @league = create(:league, name: 'marks league')
      end

      it 'returns the slug for league created' do
        expect(@league.to_param).to eq('marks-league')
      end
    end
  end
end
