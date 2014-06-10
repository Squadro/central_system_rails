PredictaWebapp::Application.routes.draw do
  root 'application#root'
  
  resources :colors
  
  post "/uploads" => "uploads#create"
end
