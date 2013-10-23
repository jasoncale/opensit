Opensit::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "users#me"

  devise_for :users, :controllers => { :registrations => "registrations" }
  get 'me' => "users#me"
  get 'my' => "users#my_sits"
  get '/users/:id' => "users#show", :as => :user
  get '/users/:id/profile' => "users#profile", :as => :profile
  get '/users/:id/following' => "users#following", :as => :following_user
  get '/users/:id/followers' => "users#followers", :as => :followers_user
  get '/users/:id/export' => "users#export"
  get '/users/:id/feed' => "users#feed", :as => :feed, :defaults => { :format => 'atom' }
  get '/favs' => "favourites#index", :as => :favs

  get 'front' => "pages#front"
  get 'about' => "pages#about"
  get 'contact' => "pages#contact"
  get 'explore' => "pages#explore"

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
