Terappel::Application.routes.draw do
  mount JasmineRails::Engine => "/jasmine" if defined?(JasmineRails)
  devise_for :users
  as :user do
    get "login", to: "devise/sessions#new"
    get "logout", to: "devise/sessions#destroy"
  end

  get "home/dossiers"
  get "/try_new_dossier", to: "home#try_new_dossier"

  resources :searches
  resources :dossiers

  resources :produits, only: :index
  resources :indications, only: :index
  resources :dcis, only: :index
  resources :malformations, only: :index
  resources :pathologies, only: :index

  get "malformations/tree", to: 'malformations#tree'
  get "malformations/ancestors", to: 'malformations#ancestors'
  get "pathologies/tree", to: 'pathologies#tree'
  get "pathologies/ancestors", to: 'pathologies#ancestors'

  resources :correspondants, except: :destroy

  namespace :admin do
    get "tables_generales", to: "thesaurus#dashboard"
    get "tables_generales/:name", to: "thesaurus#index", as: "thesaurus"
    match "tables_generales/:name/new", to: "thesaurus#new", via: :get, as: "new_libelle"
    match "tables_generales/:name/:id", to: "thesaurus#create", via: :post
    match "tables_generales/:name/:id/edit", to: "thesaurus#edit", via: :get, as: "edit_libelle"
    match "tables_generales/:name/:id", to: "thesaurus#update", via: [:patch, :put]
    match "tables_generales/:name/:id", to: "thesaurus#destroy", via: :delete, as: "destroy_libelle"
    resources :produits
    resources :users do
      put 'approve', on: :member
    end
  end

  root to: "home#index"
end
