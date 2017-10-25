require 'rails_helper'

describe 'Logged in user cannot visit sign_in path', type: :feature do
  it 'redirects the user to the root path' do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit sign_in_path

    expect(current_path).to eq(root_path)
  end
end
