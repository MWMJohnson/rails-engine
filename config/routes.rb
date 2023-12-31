Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      get "/items/find", to: "items/search#show"
      resources :merchants, only: [:index, :show] do 
        collection do
          get 'find_all'
        end
        resources :items, only: [:index], controller: 'merchants/items'
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, only: [:index], controller: 'items/merchant'
      end
    end
  end
end
