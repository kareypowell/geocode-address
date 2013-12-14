GeocodeAddress::Application.routes.draw do

  resources :members do
    collection { post :import }
  end

  root 'static_pages#home'
  match '/help',  to: 'static_pages#help',  via: 'get'
  match '/about', to: 'static_pages#about', via: 'get'

end
