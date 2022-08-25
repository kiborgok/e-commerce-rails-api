Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"


  post "/signup", to: "users#create"
  post "/login", to: "sessions#create"
  get "/me", to: "users#show"
  delete "/logout", to: "sessions#destroy"
  delete "/products/:id", to: "products#destroy"
  resources :products, only: [:index, :create]
  resources :orders, only: [:index, :create, :show]

  post "/result", to: "orders#result"
end
