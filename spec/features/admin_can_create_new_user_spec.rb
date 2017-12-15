require 'rails_helper'

describe 'Admin can create a new user', type: :feature do
  let(:league) { create(:league) }
  let(:admin) { league.creator }

  context 'for an admin' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    end

    it 'creates a new user and redirects to league users path' do
      visit league_path(league)

      click_link 'New Player'
      fill_in 'E-Mail Address', with: 'a@b.com'
      fill_in 'First Name', with: 'Mark'
      fill_in 'Last Name', with: 'Miranda'
      click_button 'Create Player!'

      expect(current_path).to eq(league_users_path(league))
      expect(page).to have_content('Mark Miranda')
      expect(page).to have_button('Invite')
    end

    it 'creates and invites a new user and redirects to league users path' do
      visit new_league_user_path(league)

      fill_in 'E-Mail Address', with: 'a@b.com'
      fill_in 'First Name', with: 'Mark'
      fill_in 'Last Name', with: 'Miranda'
      find(:css, '#invite_user').set(true)
      click_button 'Create Player!'

      expect(current_path).to eq(league_users_path(league))
      expect(page).to have_content('Mark Miranda')
      expect(page).to have_button('Invite', disabled: true)
    end

    it 'creates an admin by checking the admin box' do
      visit new_league_user_path(league)

      fill_in 'E-Mail Address', with: 'a@b.com'
      fill_in 'First Name', with: 'Mark'
      fill_in 'Last Name', with: 'Miranda'
      find(:css, '#create_admin').set(true)
      click_button 'Create Player!'

      expect(current_path).to eq(league_users_path(league))
      expect(page).to have_content('Mark Miranda')
      expect(page).to have_button('Make Admin', disabled: true)
    end
  end

  context 'as a visitor' do
    let(:member) do
      user = create(:user)
      league.grant_membership(user)
      user
    end

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(member)
    end

    it 'does not have a new player link' do
      visit league_path(league)

      expect(page).to have_content(league.name)
      expect(page).to_not have_link('New Player')
    end
  end
end
