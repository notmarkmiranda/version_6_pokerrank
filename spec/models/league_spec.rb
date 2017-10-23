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
  end

  context 'methods' do
    before do
      @league = create(:league, name: 'marks league')
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
