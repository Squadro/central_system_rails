PredictaWebapp::Application.routes.draw do
  root 'application#root'
  
  #TODO : restrict the actions on each of the resources
  resources :colors
  resources :clients
  
  post "/uploads" => "uploads#create"
end
