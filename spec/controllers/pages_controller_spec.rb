require 'rails_helper'

describe PagesController, type: :controller do
  context 'GET#home' do
    it 'renders the home template' do
      get :home
      expect(response).to render_template(:home)
    end
  end
end
