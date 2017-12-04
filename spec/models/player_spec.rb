require 'rails_helper'

describe Player, type: :model do
  context 'validations'
  context 'relationships' do
    it { should belong_to :game }
    it { should belong_to :user }
  end
  context 'methods'
end
