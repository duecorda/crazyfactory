Rails.application.routes.draw do

  get "/films", to: "main#films", as: 'films'
  get "/photos", to: "main#photos", as: 'photos'
  get "/pricing", to: "main#pricing", as: 'pricing'

  resources :asks

  root to: "main#index"

end
