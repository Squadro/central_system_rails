PredictaWebapp::Application.routes.draw do
  root 'application#root'
    
  devise_for :users
  resources :users, except: [:index]
  
  #TODO : restrict the actions on each of the resources
  resources :colors
  resources :clients
  resources :product_codes
  resources :palettes do
    member do
      get'manage'
    end
  end
  
  resources :products
  
  get 'auth_token' => 'application#auth_token'
  post "/uploads" => "uploads#create"
end
