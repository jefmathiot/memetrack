Rails.application.routes.draw do
  resources :memes
  root 'memes#index'
end
