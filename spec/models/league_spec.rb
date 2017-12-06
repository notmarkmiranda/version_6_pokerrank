require 'rails_helper'

describe League, type: :model do

  context 'validations' do
    before do
      create(:league)
    end

    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :slug }
    it { should validate_presence_of :user_id }
  end

  context 'relationships' do
    it { should belong_to :creator }
    it { should have_many :user_league_roles }
    it { should have_many :seasons }
  end

  context 'methods' do
    before do
      @league = create(:league, name: 'marks league')
    end

    context '#active_season' do
      it 'returns the active season when only one season exists' do
        expect(@league.active_season).to eq(@league.seasons.first)
      end

      it 'returns the active season when there are multiple seasons' do
        last_season = @league.seasons.first
        season = @league.seasons.create!(active: true)

        expect(@league.active_season).to eq(season)
        expect(@league.active_season).to_not eq(last_season)
      end

      it 'returns nil for no active season' do
        @league.seasons.first.update(active: false)

        expect(@league.active_season).to be nil
      end
    end

    context '#admins' do
      it 'returns the admin for the league' do
        expect(@league.admins).to eq([@league.creator])
      end

      it 'returns multiple admins for the league' do
        users = create_list(:user, 2)
        @league.grant_admin(users[0])

        expect(@league.admins).to include(@league.creator, users[0])
        expect(@league.admins).to_not include(users[1])
      end

      it 'returns an empty array for no admins' do
        @league.grant_membership(@league.creator)

        expect(@league.admins).to eq([])
      end
    end

    context '#all_possible_players' do
      let(:league) { create(:league) }
      let(:admin) { league.creator }
      let!(:member) do
        user = create(:user)
        league.grant_membership(user)
        user
      end

      it 'returns all possible players for a league' do
        expect(league.all_possible_players).to match([admin, member])
      end
    end

    context '#grant_memberhip' do
      it 'grants membership to a user' do
        new_user = create(:user)

        expect {
          @league.grant_membership(new_user)
        }.to change(@league.members, :count).by(1)
         .and change(@league.admins, :count).by(0)
      end

      it 'does not grant membership to someone that is already a member' do
        new_user = create(:user)
        @league.grant_membership(new_user)

        expect {
          @league.grant_membership(new_user)
        }.to_not change(@league.members, :count)
      end

      it 'can change someone from an admin to a member' do
        admin = @league.creator

        expect {
          @league.grant_membership(admin)
        }.to change(@league.admins, :count).by(-1)
         .and change(@league.members, :count).by(1)
      end
    end

    context '#grant_admin' do
      it 'grants admin to a user' do
        new_admin = create(:user)

        expect {
          @league.grant_admin(new_admin)
        }.to change(@league.admins, :count).by(1)
          .and change(@league.members, :count).by(0)
      end

      it 'does not grant admin for someone that is already an admin' do
        new_admin = create(:user)
        @league.grant_admin(new_admin)

        expect {
          @league.grant_admin(new_admin)
        }.to_not change(@league.admins, :count)
      end

      it 'can change someone from a member to an admin' do
        new_member = create(:user)
        @league.grant_membership(new_member)

        expect {
          @league.grant_admin(new_member)
        }.to change(@league.admins, :count).by(1)
         .and change(@league.members, :count).by(-1)
      end
    end


    context '#find' do
      it 'finds a league' do
        expect(League.find('marks-league')).to eq(@league)
      end

      it 'returns nil with no league' do
        expect(League.find('not-marks-league')).to be nil
      end
    end

    context '#to_param' do
      it 'returns the slug for league created' do
        expect(@league.to_param).to eq('marks-league')
      end
    end
  end
end
