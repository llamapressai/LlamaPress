Rails.application.routes.draw do
  resources :static_web_pages do
    member do
      get 'histories'
      post 'restore'
    end
  end
  resources :static_web_sites
  resources :static_web_page_histories
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users
  resources :organizations
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "static_web_pages#index"

  post "llama_bot/message" => "llama_bot#message", as: :llama_bot_message
  get "llama_bot/source" => "llama_bot#source", as: :llama_bot_source
  get "llama_bot/models" => "llama_bot#models", as: :llama_bot_models
  get "llama_bot/database" => "llama_bot#database", as: :llama_bot_database
  get "llama_bot/templates" => "llama_bot#templates", as: :llama_bot_templates
end