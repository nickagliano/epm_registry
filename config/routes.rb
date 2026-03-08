Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "health" => "rails/health#show"

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

  get "/docs",       to: "docs#show", as: :docs_root, defaults: { path: "concepts/what-is-eps" }
  get "/docs/*path", to: "docs#show", as: :docs

  get "/news",      to: "news#index", as: :news_index
  get "/news/:slug", to: "news#show",  as: :news

  root "packages#index"
  resources :packages, only: [ :index, :show ]
end
