Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users,         only: [ :show, :create ]
  resources :sessions,      only: [ :create ]
  resources :messages,      only: [ :create ]

  resources :conversations, only: [ :show, :create, :destroy ] 

  mount ActionCable.server => '/cable'
end
