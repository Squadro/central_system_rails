PredictaWebapp::Application.routes.draw do
  root 'application#root'
  
  #TODO : restrict the actions on each of the resources
  resources :colors
  resources :clients
  resources :product_codes
  resources :palettes
  
  post "/uploads" => "uploads#create"
end
