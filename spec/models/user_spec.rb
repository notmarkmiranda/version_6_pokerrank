require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    xit { should validate_presence_of(:email) }
    xit { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_uniqueness_of(:first_name).scoped_to(:last_name) }
    it { should validate_presence_of(:last_name) }
  end

  context 'relationships' do
    it { should have_many :leagues }
    it { should have_many :user_league_roles }
  end
end
