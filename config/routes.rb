Opensit::Application.routes.draw do

  root :to => "pages#front"

  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }
  get 'me' => "users#me"

  constraints(:username => /[^\/]+/) do
    get '/u/:username' => "users#show", :as => :user
    get '/u/:username/following' => "users#following", :as => :following_user
    get '/u/:username/followers' => "users#followers", :as => :followers_user
    get '/u/:username/export' => "users#export"
    get '/u/:username/feed' => "users#feed", :as => :feed, :defaults => { :format => 'atom' }
  end

  get '/favs' => "favourites#index", :as => :favs
  get '/notifications' => "notifications#index"
  get '/welcome' => "users#welcome"
  get '/search' => "search#main"
  get 'about' => "pages#about"
  get 'contribute' => "pages#contribute"
  get 'contact' => "pages#contact"
  get 'explore' => "pages#explore"
  get 'explore/tags' => "pages#tag_cloud", :as => :explore_tags
  get 'explore/comments' => "pages#new_comments", :as => :explore_comments
  get 'explore/users/online' => "pages#online_users", as: :explore_online_users
  get 'explore/users/new' => "pages#new_users", :as => :explore_new_users
  get 'explore/users/active' => "pages#active_users", :as => :explore_active_users
  get 'explore/users/new/sitters' => "pages#new_sitters", :as => :explore_new_sitters
  get 'global-feed' => "users#feed", :defaults => { :format => 'atom', :scope => 'global' }
  get 'calendar' => "pages#calendar", :as => :calendar

  resources :sits do
    resources :comments
  end

  get '/tags/:id' => 'tags#show', :as => :tag
  get '/messages/sent' => "messages#sent", :as => :sent_messages
  resources :messages, except: [:edit, :update]
  resources :relationships, only: [:create, :destroy]
  resources :favourites, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :goals

  # Crawl live site, but not staging
  get 'robots.txt' => 'pages#robots'

  get "/split" => Split::Dashboard, :anchor => false, :constraints => lambda { |request|
    request.env['warden'].authenticated?
    request.env['warden'].authenticate!
    request.env['warden'].user.email == "danbartlett@gmail.com"
  }
end
