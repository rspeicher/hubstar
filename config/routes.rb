Hubstar::Application.routes.draw do
  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'sessions#failure'
  get 'sign_in', :to => 'sessions#new', :as => :sign_in
  delete 'sign_out', :to => 'sessions#destroy', :as => :sign_out

  get 'about', :to => 'dashboard#about', :as => :about

  resources :repositories, :only => [:index, :show], :id => /[\w\-\+\/\.]+/
  resource :star, :only => [:update, :destroy]

  root :to => 'dashboard#index'
end
