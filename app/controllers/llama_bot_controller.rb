require Rails.root.join('lib', 'llama_bot.rb')
require 'securerandom'

class LlamaBotController < ApplicationController
    include ActionController::Live
    skip_before_action :verify_authenticity_token, only: [:message]

    #/home
    def home
      #llama bot home page
      @sites = current_organization.sites
      @pages = current_organization.pages
    end

    def message
      user_message = params[:message]
      context = params[:context]
      selectedElement = params[:selectedElement].present? && !params[:selectedElement].empty? ? params[:selectedElement] : nil
      webPageId = params[:webPageId]
      
      if user_message.include?("ave snippet:") && selectedElement.present?
        # Save snippet logic (unchanged)
        # Parse the selectedElement HTML
        doc = Nokogiri::HTML.fragment(selectedElement)

         # Find all elements with 'data-llama-id' and replace the value with a UUID
        doc.css('[data-llama-id]').each do |node|
          node['data-llama-id'] = SecureRandom.uuid
        end

        updated_selectedElement = doc.to_html 

        snippet_name = user_message.split(":")[1] # get snippet name by splitting on :
        page = Page.find_by(id: webPageId)
        snippet = Snippet.new(name: snippet_name, content: updated_selectedElement, site_id: page.site_id)
        snippet.save
        llama_bot_response = "Snippet saved"
        render json: { response: llama_bot_response }
      else 
        LlamaBot.completion(user_message, context, selectedElement, webPageId, session_id)
        head :ok
      end

      # Things needed: 
      # 1. Stop Button (user can press LlamaBot Javascript button to stop the bot).
      # 2. Discuss with Danish - contenteditable so that users can edit content they select with llamabot.
        # 2a. Something to take HTML from llamabot js client and save to the webpage.
      
      #TODO: Save llama_bot_response to the database. How do we do this? 
      
      # llama_message = LlamaMessage.new(user_message: user_message, bot_message: llama_bot_response, web_page_id: webPageId)
      # llama_bot_message.save #user_id 
      # from: llama_bot.rb
      # llama_message.save

      #TODO: Do we keep this route now that we have websocket connection?
      # render json: { response: llama_bot_response }
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
end
