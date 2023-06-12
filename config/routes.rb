Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'products#index'
  get '/products', to: 'products#index'
  get '/products/new', to: 'products#new', as: 'new_product'
  get '/products/:id', to: 'products#show'
  post '/products', to: 'products#create', as: 'create_product'
  delete '/products/:id', to: 'products#destroy', as: 'delete_product'
  get 'products/:id/edit', to: 'products#edit', as: 'edit_product'
  patch 'products/:id', to: 'products#update', as: 'update_product'
end
