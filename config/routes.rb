Rails.application.routes.draw do
  resources :rails_girls

  root to: 'rails_girls#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
