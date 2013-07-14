Opensit::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "users#me"

  devise_for :users, :controllers => { :registrations => "registrations" }
  match 'me' => "users#me"
  match 'my' => "users#my_sits"
  match '/users/:id' => "users#show", :as => :user
  match '/users/:id/profile' => "users#profile", :as => :profile
  match '/users/:id/following' => "users#following", :as => :following_user
  match '/users/:id/followers' => "users#followers", :as => :followers_user
  match '/users/:id/export' => "users#export"
  match '/users/:id/feed' => "users#feed", :as => :feed, :defaults => { :format => 'atom' }
  match 'favs' => "favourites#index", :as => :favs

  match 'front' => "pages#front"
  match 'about' => "pages#about"
  match 'contact' => "pages#contact"
  match 'explore' => "pages#explore"

  resources :sits do
    resources :comments
  end

  match '/tags/:id' => 'tags#show', :as => :tag

  match '/messages/sent' => "messages#sent", :as => :sent_messages
  resources :messages, except: [:edit, :update]
  
  resources :relationships, only: [:create, :destroy]

  resources :favourites, only: [:create, :destroy]

  ActiveAdmin.routes(self)

end
