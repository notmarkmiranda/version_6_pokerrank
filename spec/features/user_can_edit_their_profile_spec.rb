require 'rails_helper'

describe 'User can edit their profile', type: :feature do
  context 'happiest of paths' do
    before do
      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'allows them to update their information with all required fields' do
      visit edit_profile_path

      fill_in 'First Name', with: 'Jonathan'
      click_button('Update Profile!')

      expect(current_path).to eq(dashboard_path)
    end

    it 'does not allow them to update their information with missing fields' do
      visit edit_profile_path

      fill_in 'First Name', with: ''
      click_button('Update Profile')

      expect(page).to have_button('Update Profile!')
    end
  end
end
