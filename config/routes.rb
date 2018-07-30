Rails.application.routes.draw do

  get "/films", to: "main#films", as: 'films'
  get "/photos", to: "main#photos", as: 'photos'
  get "/pricing", to: "main#pricing", as: 'pricing'

  get "/show/:id", to: "main#show", as: 'show'

  resources :asks
  resources :photos

  root to: "main#index"

  scope '/admin' do
    resources :articles do
      collection do
        get "/asks", action: "asks"
        get "/answer", action: "new_answer"
        get "/edit_answer", action: "edit_answer"
      end
    end

    get "/", to: "articles#index"
  end

end
