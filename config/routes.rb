Opensit::Application.routes.draw do
  
  root :to => "users#me"

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  
  devise_for :users, :controllers => { :registrations => "registrations" }
  match 'me' => "users#me"
  match 'my' => "users#my_sits"
  match '/users/:id' => "users#show", :as => :user
  match '/users/:id/bio' => "users#bio", :as => :bio
  match '/users/:id/following' => "users#following", :as => :following_user
  match '/users/:id/followers' => "users#followers", :as => :followers_user
  match '/users/:id/export' => "users#export"
  match '/users/:id/feed' => "users#feed", :as => :feed, :defaults => { :format => 'atom' }

  match 'front' => "static_pages#front"
  match 'about' => "static_pages#about"

  resources :sits do
    resources :comments
  end

  match '/tags/', to: 'tags#index', as: :tags
  match '/tags/:id', to: 'tags#show', as: :tag

  match '/messages/sent' => "messages#sent", :as => :sent_messages
  resources :messages, except: [:edit, :update]
  
  resources :relationships, only: [:create, :destroy]

end
