Enki::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    user = Devise.mappings[:user]

    with_devise_exclusive_scope user.fullpath, user.name do
      devise_session user, user.controllers
    end
  end
  
  namespace :users do
    resources :authentications, :only => [:index, :destroy]
  end
  
  namespace :admin do
    resource :session

    resources :posts, :pages do
      post 'preview', :on => :collection
    end
    resources :comments
    resources :undo_items do
      post 'undo', :on => :member
    end

    match 'health(/:action)' => 'health', :action => 'index', :as => :health

    root :to => 'dashboard#show'
  end

  resources :archives, :only => [:index]
  resources :pages, :only => [:show]
  resources :posts, :only => [:show]
  
  constraints :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/ do
    post ':year/:month/:day/:slug/comments' => 'comments#index'
    get ':year/:month/:day/:slug/comments/new' => 'comments#new'
    get ':year/:month/:day/:slug' => 'posts#show'
  end

  scope :to => 'posts#index' do
    get 'posts.:format', :as => :formatted_posts
    get '(:tag)', :as => :posts
  end

  root :to => 'posts#index'
end
