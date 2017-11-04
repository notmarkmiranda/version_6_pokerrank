require 'rails_helper'

describe Season, type: :model do
  context 'validations' do
    it { should validate_presence_of :league_id }
    it { should validate_presence_of :active }
  end

  context 'relationships' do
    it { should belong_to :league }
  end

  context 'methods' do

  end
end
