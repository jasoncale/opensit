Opensit::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "users#me"

  devise_for :users, :controllers => { :registrations => "registrations" }
  get 'me' => "users#me"
  get '/users/:username' => "users#show"
  get '/users/:username/profile' => "users#profile", :as => :profile
  get '/users/:username/following' => "users#following", :as => :following_user
  get '/users/:username/followers' => "users#followers", :as => :followers_user
  get '/users/:username/export' => "users#export"
  get '/users/:username/feed' => "users#feed", :as => :feed, :defaults => { :format => 'atom' }
  get '/favs' => "favourites#index", :as => :favs
  get '/notifications' => "notifications#index"

  get '/search' => "search#main"

  get 'front' => "pages#front"
  get 'about' => "pages#about"
  get 'contact' => "pages#contact"
  get 'explore' => "users#explore"
  get 'global-feed' => "users#feed", :defaults => { :format => 'atom', :scope => 'global' }

  get '/:username' => "users#show", :as => :user
  
  resources :sits do
    resources :comments
  end

  get '/tags/:id' => 'tags#show', :as => :tag

  get '/messages/sent' => "messages#sent", :as => :sent_messages
  resources :messages, except: [:edit, :update]
  
  resources :relationships, only: [:create, :destroy]

  resources :favourites, only: [:create, :destroy]

  ActiveAdmin.routes(self)

end
