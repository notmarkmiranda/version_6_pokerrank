require 'rails_helper'

describe 'Admin of a league can toggle uncompleted flag', type: :request do
  let(:game) { create(:game, completed: true) }
  let(:league) { game.league }
  let(:admin) { league.creator }
  let(:season) { game.season }
  let(:member) do
    user = create(:user)
    league.grant_membership(user)
    user
  end

  context 'as an admin' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    end

    it 'allows an admin to toggle a game as completed' do
      expect {
        patch "/leagues/#{league.slug}/seasons/#{season.id}/games/#{game.id}/uncompleted"
      }.to change { game.reload.completed }.from(true).to(false)
    end

    it 'allows a game that is already completed to still process through' do
      game.uncomplete!
      expect {
        patch "/leagues/#{league.slug}/seasons/#{season.id}/games/#{game.id}/uncompleted"
      }.to_not change { game.completed }.from(false)
    end
  end

  context 'as a member' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(member)
    end

    it 'does not allow a member to toggle a game as uncompleted' do
      expect {
        patch "/leagues/#{league.slug}/seasons/#{season.id}/games/#{game.id}/uncompleted"
      }.to_not change { game.reload.completed }.from(true)
    end
  end

  context 'as a visitor' do
    it 'does not allow a visitor to toggle a game as uncompleted' do
      expect {
        patch "/leagues/#{league.slug}/seasons/#{season.id}/games/#{game.id}/uncompleted"
      }.to_not change { game.reload.completed }.from(true)
    end
  end

end
