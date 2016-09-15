Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  # You can have the root of your site routed with "root"
  root 'static_pages#index'

  devise_for :users, path_names:  { sign_in: "login", sign_out: "logout" },
                     controllers: {
                                    registrations: "users/registrations"
                                  }

  #===============Api Routes================
   require 'api_constraints'

   namespace :api, defaults: { format: :json } do
       # scope per version of api
       scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

         resources :sessions, :only      => [:create, :destroy]
         match '/login'                  => 'sessions#create', :via => [:options, :post]
         post '/logout/:user_id'         => 'sessions#destroy'

         match '/users/:id'              => 'users#update', :via => [:options, :put, :post]
         get '/matches'                  => 'matches#show'
        #  match '/s3_access_signature'       => 's3_signature#s3_access_token'

         resources :users, :only         => [:show, :create, :update]
     end
   end
   #==========================================

  resources :users do
    resources :gyms
  end

  resources :users, only:[:show] #User profile
  resources :gyms, only: [:show]

  get 'matches' => "matches#show"
end
