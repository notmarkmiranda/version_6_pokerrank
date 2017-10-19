require 'rails_helper'

describe 'Visitor can sign up', type: :feature do
  it 'allows a visitor to sign up with all required fields' do
    visit sign_up_path

    fill_in 'E-Mail Address', with: 'test@example.com'
    fill_in 'First Name', with: 'Johnny'
    fill_in 'Last Name', with: 'Appleseed'
    fill_in 'Password', with: 'password'
    click_button 'Sign Up!'

    expect(current_path).to eq(dashboard_path)
  end

  it 'does not allow a visitor to sign up with missing required fields' do
    visit sign_up_path

    fill_in 'E-Mail Address', with: 'test@example.com'
    fill_in 'First Name', with: 'Johnny'
    fill_in 'Password', with: 'password'
    click_button 'Sign Up!'

    expect(page).to have_button('Sign Up!')
  end
end
