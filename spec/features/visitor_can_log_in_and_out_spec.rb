require 'rails_helper'

describe 'Visitor can log in and out', type: :feature do
  it 'allows a visitor to log in and out' do
    user = create(:user)

    visit sign_in_path

    fill_in 'E-Mail Address', with: user.email
    fill_in 'Password', with: 'password'

    click_button 'Sign In!'

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_link('Sign Out')
    expect(page).to_not have_link('Sign In')

    click_link 'Sign Out'

    expect(current_path).to eq(root_path)
    expect(page).to have_link('Sign In')
  end
end
