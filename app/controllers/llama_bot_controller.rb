require 'securerandom'

class LlamaBotController < ApplicationController
    include ActionController::Live
    skip_before_action :verify_authenticity_token, only: [:message]
    skip_before_action :authenticate_user!, only: [:source_code]

    #/home
    def home
      #llama bot home page
      @sites = current_organization.sites
      @pages = current_organization.pages
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
      source_files = Dir.glob(Rails.root.join('app', '**', '*')).select { |file| File.file?(file) }
      source_code_contents = source_files.map do |file|
        { path: file.sub(Rails.root.to_s + '/', ''), content: File.read(file) }
      end

      render json: source_code_contents
    end

    before_action :authenticate_external_system, only: [:source_code]

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
