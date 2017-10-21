require 'rails_helper'

describe 'user can create a league', type: :feature do
  before do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  scenario 'with all valid parameters, it creates a league' do
    visit new_league_path
    fill_in 'League Name', with: 'Super Duper League'
    click_button 'Create League!'

    expect(current_path).to eq(league_path(slug: 'super-duper-league'))
    expect(page).to have_content('Super Duper League')
  end

  scenario 'without a name, it does not create a league' do
    visit new_league_path
    click_button 'Create League!'

    expect(page).to have_button('Create League!')
  end
end
