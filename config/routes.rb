RainCms::Application.routes.draw do
  
  resources :comments

  #routes for admin ==============================
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  mount Ckeditor::Engine => '/ckeditor'
  namespace :admin do
    resources :pages
    resources :channels
    resources :keystores
    resources :comments
    get "home/ckeditor_pictures"
    get "home/help"
    get "templetes/index"
    get "templetes/show"
    get "templetes/new"
    post "templetes/create"
    get "templetes/edit"
    post "templetes/update"
    get "templetes/destroy"
    get "templetes/update_cache"
  end
  #routes for front ==============================
  root :to => "welcome#index"
  
  #match search/tag special path
  match '/search(/page/:page)', to: "welcome#search", via: :get, as: 'search'
  match '/tag/:tag(/page/:page)', to: "welcome#tag", as: 'tag', via: :get
  
  #match '/:profession/:state_code/:dik/:classify_type/(:action(/:id))' => 
  #  'sanction', 
  #  :constraints => { :dik => /\d{4}.\d{2}.\d{2}/,  
  #  :classify_type => /title|date|skip/ }
  match '/:channel(/:id)', to: "welcome#index", via: :get
  match '/:channel(/page/:page)', to: "welcome#index", via: :get


end
