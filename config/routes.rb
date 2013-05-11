Terappel::Application.routes.draw do

  devise_for :users
  as :user do
    get "/login", :to => "devise/sessions#new"
    get "/logout", :to=> "devise/sessions#destroy"
  end

  #mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get "home/dossiers"
  get "/try_new_dossier", to: "home#try_new_dossier"

  resources :searches
  resources :dossiers do
    get :autocomplete_correspondant_fullname, :on => :collection
    get :produits, :on => :collection
    get :indications, :on => :collection
    get :correspondants, :on => :collection
  end
  resources :users, :only => [:show, :edit, :update]

  resources :malformations, :only => :index
  resources :pathologies, :only => :index
  match 'malformations/tree' => 'malformations#tree'
  match 'malformations/ancestors' => 'malformations#ancestors'
  match 'pathologies/tree' => 'pathologies#tree'
  match 'pathologies/ancestors' => 'pathologies#ancestors'

  resources :correspondants, :only => [:show, :new, :create, :edit, :update]

  root :to => "home#index"
end
