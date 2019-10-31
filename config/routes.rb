Rails.application.routes.draw do
  get '/', to: 'welcome#index'
  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile/update', to: 'users#update'
  get '/profile/change-password', to: 'users#edit_password'
  patch '/profile/update-password', to: 'users#update_password'

  resources :merchants, only: [:index, :show] do
    resources :items, only: [:index]
  end

  resources :items, only: [:index, :show] do
    namespace :profile do
      get '/reviews/new', to: 'reviews#new'
      post '/reviews/create', to: 'reviews#create'
      get '/reviews/:review_id/edit', to: 'reviews#edit'
      patch '/reviews/:review_id', to: 'reviews#update'
      delete '/reviews/:review_id', to: 'reviews#destroy'
    end
  end

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'
  patch '/cart/:item_id/:increment_decrement', to: 'cart#increment_decrement'

  namespace :profile do
    resources :orders, only: [:create, :index, :show, :update]
  end

  namespace :merchant do
    get '/', to: 'dashboard#index'
    resources :items, except: [:show]
    patch '/items/:id/disable', to: 'items#deactivate'
    patch '/items/:id/enable', to: 'items#activate'
    patch '/orders/:order_id/items/:item_id', to: 'items#fulfill'
    get '/orders/:id', to: 'orders#show'
    get '/merchants/:id/edit', to: 'dashboard#edit'
    patch '/merchants/:id', to: 'dashboard#update'
  end

  namespace :admin do
    resources :merchants, except: [:index]
    get '/', to: 'dashboard#index'
    patch '/orders/:id/ship', to: 'orders#ship'
    patch '/merchants/:id/disable', to: 'merchants#disable'
    patch '/merchants/:id/enable', to: 'merchants#enable'
    resources :users, only: [:index, :show]
  end
end
