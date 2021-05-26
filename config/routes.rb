Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "products#index"
  resources :products
  get '/payments/success', to: 'orders#success'
  post '/payments/webhook', to: 'orders#webhook'
  get '/orders', to: 'orders#index', as: 'orders'
  resources :reviews
end

