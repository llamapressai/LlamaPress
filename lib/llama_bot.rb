require 'net/http'
require 'uri'
require 'json'

module LlamaBot
    class << self
        def completion(user_message, context=nil, selectedElement=nil, webPageId=nil)
            response = llama_bot_completion(user_message, context, selectedElement, webPageId)
            
            case response['decision']
            when "GENERATE_SCAFFOLD_COMMAND"
                return "Hey! You're in a sandbox mode and are unable to create new database tables or make changes to the source code. If you want a full-fledged llamapress instance, please reach out to our support team. kody@fieldrocket.us."
            end
        end

        private

        def llama_bot_completion(user_message, context=nil, selectedElement=nil, webPageId=nil)
            params = {
                'user_message' => user_message,
                'context' => context,
                'selectedElement' => selectedElement,
                'webPageId' => webPageId
            }.compact
            
            response = JSON.parse(make_get_request(ENV['LLAMA_BOT_URI'], params))
            return response
        end

        # Make a GET request to the LlamaBot API
        def make_get_request(base_url, params)
            uri = URI.parse(base_url)
            uri.query = URI.encode_www_form(params)
            
            response = Net::HTTP.get_response(uri)
            response.body
        end
    end
end