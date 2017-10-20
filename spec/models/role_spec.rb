require 'rails_helper'

describe Role, type: :model do
  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end
end
