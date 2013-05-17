Terappel::Application.routes.draw do
  mount JasmineRails::Engine => "/jasmine" if defined?(JasmineRails)
  devise_for :users
  as :user do
    get "login", to: "devise/sessions#new"
    get "logout", to: "devise/sessions#destroy"
  end

  #mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get "home/dossiers"
  get "/try_new_dossier", to: "home#try_new_dossier"

  resources :searches
  resources :dossiers do
    get :autocomplete_correspondant_fullname, on: :collection
    get :produits, on: :collection
    get :indications, on: :collection
  end

  resources :correspondants, only: :index

  resources :malformations, only: :index
  resources :pathologies, only: :index
  get "malformations/tree", to: 'malformations#tree'
  get "malformations/ancestors", to: 'malformations#ancestors'
  get "pathologies/tree", to: 'pathologies#tree'
  get "pathologies/ancestors", to: 'pathologies#ancestors'

  resources :correspondants, only: [:show, :new, :create, :edit, :update]

  root to: "home#index"
end
