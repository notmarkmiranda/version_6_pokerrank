Rails.application.routes.draw do
  root 'pages#home'
  resources :users, only: [:index, :show, :create, :update], path_names: { show: 'dashboard' }
  resources :leagues, except: [:delete], param: :slug do
    resources :seasons, only: [:show, :create]
  end

  get '/sign-up', to: 'users#new', as: 'sign_up'
  get '/dashboard', to: 'users#show', as: 'dashboard'
  get 'edit-profile', to: 'users#edit', as: 'edit_profile'

  get '/sign-in', to: 'sessions#new', as: 'sign_in'
  post '/sign-in', to: 'sessions#create'
  get '/sign-out', to: 'sessions#destroy', as: 'sign_out'
end
