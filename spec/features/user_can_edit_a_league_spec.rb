require 'rails_helper'

describe 'User can edit a league name', type: :feature do
  before do
    @league = create(:league)
    user = @league.creator
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it 'changes the name and slug, redirects back to league path' do
    visit edit_league_path(@league)

    fill_in 'League Name', with: 'New League Name'
    click_button 'Update League!'

    expect(current_path).to eq(league_path(slug: 'new-league-name'))
    expect(page).to have_content('New League Name')
  end

  it 'renders the edit template if there is no name' do
    visit edit_league_path(@league)

    fill_in 'League Name', with: ''
    click_button 'Update League!'

    expect(page).to have_button('Update League!')
  end
end
