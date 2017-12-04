require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_uniqueness_of(:first_name).scoped_to(:last_name) }
    it { should validate_presence_of(:last_name) }
  end

  context 'relationships' do
    it { should have_many :created_leagues }
    it { should have_many :user_league_roles }
    it { should have_many :players }
  end

  context 'methods' do
    context '#member_leagues' do
      it 'returns leagues were the user is a member' do
        user = create(:user)
        leagues = create_list(:league, 2)
        leagues[0].grant_membership(user)

        expect(user.member_leagues).to include(leagues[0])
        expect(user.member_leagues).to_not include(leagues[1])
      end

      it 'returns no leagues where they are not a member' do
        user = create(:user)

        expect(user.member_leagues).to eq([])
      end
    end
    context '#admin_leagues' do
      it 'returns leagues where the user is an admin' do
        leagues = create_list(:league, 2)
        admin = leagues[0].creator

        expect(admin.admin_leagues).to include(leagues[0])
        expect(admin.admin_leagues).to_not include(leagues[1])
      end

      it 'returns no leagues where they are not an admin' do
        create(:league)
        user = create(:user)

        expect(user.admin_leagues).to eq([])
      end
    end
  end
end
