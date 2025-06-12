Rails.application.routes.draw do
  resources :chat_messages
  resources :chat_conversations
  resources :posts
  resources :snippets
  
  resources :submissions do
    collection do
      post :verify_phone_number_with_twilio
      post :confirm_verify_code_with_twilio
    end
  end

  get 'twilio_verify_example' => 'pages#twilio_verify_example'

  resources :pages do
    member do
      get 'histories'
      post 'restore'
      post 'publish_to_wordpress'
      post :page_undo
      post :page_redo
      post 'restore_with_history'
      get 'download_html'
    end
  end
  resources :sites
  resources :page_histories do
    member do 
      get 'list'
    end
  end

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  
  resources :users do
    put 'set_tutorial_step', on: :collection
  end
  
  resources :organizations
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "pages#home"
  
  # Mirror wordpress routes for admin
  get "wp-admin" => "llama_bot#home" 

  get "home" => "llama_bot#home", as: :llama_bot_home
  post "llama_bot/message" => "llama_bot#message", as: :llama_bot_message
  get "llama_bot/source" => "llama_bot#source", as: :llama_bot_source
  get "llama_bot/models" => "llama_bot#models", as: :llama_bot_models
  get "llama_bot/database" => "llama_bot#database", as: :llama_bot_database
  get "llama_bot/templates" => "llama_bot#templates", as: :llama_bot_templates
  get "llama_bot/templates/:template" => "llama_bot#template", as: :llama_bot_template
  get "llama_bot/get_message_history_from_llamabot_checkpoint" => "llama_bot#get_message_history_from_llamabot_checkpoint", as: :llama_bot_get_message_history_from_llamabot_checkpoint
  get '/p/:id' => 'pages#show', as: :page_show #scope /w/ pages for easier page sharing

  get '/pages/:id/preview' => 'pages#preview', as: :page_preview

  post '/attach_pre_uploaded_s3_blob_to_site', to: 'sites#attach_pre_uploaded_s3_blob_to_site'
  post '/attach_multiple_pre_uploaded_s3_blobs_to_sites', to: 'sites#attach_multiple_pre_uploaded_s3_blobs_to_sites'
  

  post 'sites/pre_signed_s3_url_for_uploading_images', to: 'sites#get_signed_s3_url_for_uploading_images'
  post '/sites/list_images', to: 'sites#list_images'

  mount ActionCable.server => '/cable'

  get 'sitemap.xml', to: 'pages#sitemap_xml', defaults: { format: 'xml' }
  get 'robots.txt', to: 'pages#robots_txt', defaults: { format: 'txt' }

  post 'api/sites/:slug/wordpress_api_token', to: 'sites#update_wordpress_token', defaults: { format: :json }
  post 'api/wordpress_sites', to: 'sites#create_wordpress_site'

  get 'picture-to-html', to: 'public_leads#new'
  
  get 'brand-clone', to: 'public_leads#brand_clone'

  get 'elementor', to: 'public_leads#elementor'

  get 'demo', to: 'public_leads#demo'

  resources :public_leads, only: [:create] do
    collection do
      post :create_from_prompt
      post :create_from_prompt_in_wordpress_registration
      post :register_and_brand_clone
    end
  end

  # A catch all route for the user clicking thumbs up or thumbs down on a llamabot message. Simplifies the javascript code
  post 'message_reactions', to: 'message_reactions#handle_reaction'

  namespace :admin do
    resources :reactions, only: [:index]
    get '/', to: 'home#index'
    get '/image_uploads', to: 'home#view_image_uploads'
  end

  get "/message_reactions_admin", to: "admin/reactions#index"
    # Make sure this is the LAST route

  get '*path', to: 'pages#resolve_slug', constraints: lambda { |request|
    !request.path.start_with?('/rails/') && 
    !request.path.start_with?('/cable') && 
    !request.path.start_with?('/page_histories')
  }
  
end