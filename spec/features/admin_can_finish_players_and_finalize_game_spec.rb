require 'rails_helper'

describe 'Admin can finalize a game', type: :feature do
  let(:game) { create(:game) }
  let(:league) { game.league }
  let(:season) { game.season }
  let(:admin) { league.creator }
  let(:users) { create_list(:user, 3) }
  let!(:members) do
    users.each { |m| league.grant_membership(m) }
    users
  end

  context 'a player that is finished does not show up in the dropdown' do
    before do
      create(:player, user_id: users[1].id, game: game)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    end

    it 'does not have a player that is finished' do
      user1, user2, user3 = members
      other_game = create(:game)
      create(:player, user_id: user3.id, game_id: other_game.id)

      visit new_league_season_game_player_path(league, season, game)
      # THIS IS WHERE YOU STOPPED IT WORK
      expect(page).to have_select('player_user_id', options: ['', admin.full_name, user1.full_name, user3.full_name])
      expect(page).not_to have_select('player_user_id', options: [user2.full_name])
    end
  end
end
