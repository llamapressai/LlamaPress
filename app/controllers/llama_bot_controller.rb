require 'securerandom'
require 'llama_bot'

class LlamaBotController < ApplicationController
    include ActionController::Live
    skip_before_action :authenticate_user!, only: [:home, :source_code]

    def get_message_history_from_llamabot_checkpoint
      @page_id = params[:page_id]
      @state_history = LlamaBot.get_message_history_from_llamabot_checkpoint(@page_id)
      render json: @state_history
    end

    #/home
    def home
      if current_user.present?
        #llama bot home page
        @sites = current_organization.sites
        @pages = current_organization.pages
      else
        redirect_to "/users/sign_up"
      end
    end

    # get /llama_bot/source
    def source
        @directory_structure = generate_directory_structure(Rails.root.join('app'))
        render 'llama_bot/source'
    end

    # get /llama_bot/database
    def database
        render 'llama_bot/database'
    end

    # get /llama_bot/models
    def models
        render 'llama_bot/models'
    end

    # get /llama_bot/templates
    def templates
      @templates = PagesHelper.get_starting_templates # get html content from each file in templates folder
      render 'llama_bot/templates'
    end

    # get /llama_bot/templates/:template
    def template
      template_name = params[:template]
      template_content = File.read(Rails.root.join('app', 'views', 'llama_bot', 'templates', "#{template_name}.html"))
      render inline: template_content
    end

    def source_code
      render json: { message: "Source code" }
    end
    
    private
    
    def generate_directory_structure(path)
        Dir.glob("#{path}/**/*").map do |file|
          {
            path: file.sub(Rails.root.to_s + '/', ''),
            type: File.directory?(file) ? 'directory' : 'file'
          }
        end
      end

    def send_message
      message = params[:message]
      session_id = params[:session_id]
      
      LlamaBot.completion(message, session_id: session_id) do |response|
        ActionCable.server.broadcast("chat_channel_#{session_id}", { message: response })
      end

      head :ok
    end

    def authenticate_external_system
      # Implement your authentication logic here
      # For example, check for a specific API key in the request headers
     
      puts "secure this"
      # api_key = request.headers['X-Api-Key']
      # head :unauthorized unless api_key == 'your-secure-api-key'
    end
end
