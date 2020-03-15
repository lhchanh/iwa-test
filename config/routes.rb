Rails.application.routes.draw do
  apipie
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "users#index"

  resources :users
  resources :tests

  devise_scope :user do
    namespace  :api, defaults: { format: :json } do
      api_path = '/api/v1'
      namespace :v1 do
        namespace :auth do
          post :login, controller: "#{api_path}/auth/login", to: 'login#create'
          delete :logout, controller: "#{api_path}/auth/login", to: 'login#destroy'
        end

        resources :tests do
          member do
            post :submit_answer
          end
        end
      end
    end
  end

end
