Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "products#index"   #Sets the products index page as the root 
  resources :products         #Sets up all the default routes for the products controller
  get '/payments/success', to: 'orders#success'     #Route to the successful payment page
  post '/payments/webhook', to: 'orders#webhook'    #Post method for the webhook from the Stripe session
  get '/orders', to: 'orders#index', as: 'orders'   #Route for purchase history
end

