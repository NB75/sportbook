Wettpool::Application.routes.draw do

  match 'signin',   :to => 'sessions#new'
  match 'signout',  :to => 'sessions#destroy'
  
  match 'about',    :to => 'pages#about'
  match 'home',     :to => 'pages#home'
  match 'style',    :to => 'pages#style'     # testpage for styles (css)

  match 'live',          :to => 'live#index'
  match 'live/:game_id', :to => 'live#show', :as => :live_game
    
  match 'time',            :to => 'time#index'
  
  match 'ical/:play_id',   :to => 'ical#index'
  
  resource :session, :only => [:new, :create, :destroy]
  
  resource :password, :only => [:new, :create, :destroy]

  resources :profiles, :only => [:index, :show]

  resources :plays  
  
  resources :pools do
    get 'add_player_to', :on => :member
    resources :players, :only => [:show, :edit]
  end

  #############
  ## routes for admin

  match 'admin',  :to => 'admin/pools#index'
  
  namespace :admin do
    resources :pools
    resources :games do
      put 'batch_update', :on => :collection    # batch update 
    end
    
    match 'bonus',         :to => 'bonus#index'
    match 'bonus/update',  :to => 'bonus#update'
  end

  ##############################
  ## routes for admin via module (admin not in url -- todo/fix)
  
  scope :module => 'admin' do

    match 'update',         :to => 'update#index'
    match 'update/update',  :to => 'update#update' # , :via => :get

    resources :jobs do
      get 'calc',            :on => :collection
      get 'debug_calc',      :on => :collection
      get 'export',          :on => :collection
      get 'keys',            :on => :collection
      get 'wipe_out_time',   :on => :collection
      get 'wipe_out',        :on => :collection
      get 'wipe_out_points', :on => :collection
    end
  
    resource :import, :only => [:create]
  
    resources :users
  end
  
  ##############################
  ## routes for db

  match 'db',  :to => 'db/games#index'

  namespace :db do
    resources :events
    resources :teams
    resources :games do
      get 'past',   :on => :collection
    end
  end
  
  ##############################
  ## routes for setup via module (setup not in url -- todo/fix??)

  match 'setup',  :to => 'setup/teams#index'

  scope :module => 'setup' do
    resources :bonus_rounds
    resources :rounds
    resources :games
    resources :calc_games
    resources :teams

    resources :events do
      post 'add_team_to', :on => :member
    end
  end

  
  #######################
  ## home route
  
  root :to => 'pages#home'
end
