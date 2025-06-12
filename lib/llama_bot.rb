module LlamaBot
    class << self
        def get_message_history_from_llamabot_checkpoint(page_id)
            #GET REQUEST TO LLAMABOT CHECKPOINT
            api_url = "#{ENV['LLAMABOT_API_URL']}/chat-history/#{page_id}"
            uri = URI(api_url)
           
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = (uri.scheme == 'https')
           
            request = Net::HTTP::Get.new(uri)
            response = http.request(request)
 
 
            state = JSON.parse(response.body)
            return state
        end
    end
 end
 