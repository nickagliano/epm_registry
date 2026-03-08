Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :packages, only: [ :index, :show, :create ] do
        resources :versions, only: [ :show ], param: :version_number,
                            constraints: { version_number: /[^\/]+/ } do
          member { patch :yank }
        end
      end
    end
  end

  root "packages#index"
  resources :packages, only: [ :index, :show ]
end
