require Rails.root.join('lib', 'llama_bot', 'llama_bot.rb')
class LlamaBotController < ApplicationController
    skip_before_action :verify_authenticity_token
    def message
      user_message = params[:message]
      context = params[:context]
      selectedElement = params[:selectedElement].present? && !params[:selectedElement].empty? ? params[:selectedElement] : nil
      webPageId = params[:webPageId]
      
      llama_bot_response = LLamaBot.completion(user_message, context, selectedElement, webPageId)
      
      render json: { response: llama_bot_response }
    end
end