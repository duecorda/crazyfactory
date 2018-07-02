Rails.application.routes.draw do

  get "/films", to: "main#films", as: 'films'
  get "/photos", to: "main#photos", as: 'photos'
  get "/pricing", to: "main#pricing", as: 'pricing'
  get "/ask", to: "main#ask", as: 'ask'

  root to: "main#index"

end
