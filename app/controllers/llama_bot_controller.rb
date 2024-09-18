require Rails.root.join('lib', 'llama_bot.rb')
class LlamaBotController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:message]

    #/home
    def home
      #llama bot home page
      @static_web_sites = current_organization.static_web_sites
      @static_web_pages = current_organization.static_web_pages
    end

    def message
      user_message = params[:message]
      context = params[:context]
      selectedElement = params[:selectedElement].present? && !params[:selectedElement].empty? ? params[:selectedElement] : nil
      webPageId = params[:webPageId]
      
      llama_bot_response = LlamaBot.completion(user_message, context, selectedElement, webPageId)

      # Things needed: 
      # 1. Stop Button (user can press LlamaBot Javascript button to stop the bot).
      # 2. Discuss with Danish - contenteditable so that users can edit content they select with llamabot.
        # 2a. Something to take HTML from llamabot js client and save to the webpage.
      
      render json: { response: llama_bot_response }
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
        render 'llama_bot/templates'
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
end