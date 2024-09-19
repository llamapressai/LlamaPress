require 'net/http'
require 'uri'
require 'json'

module LlamaBot
    class << self
        def completion(user_message, context=nil, selected_element=nil, web_page_id=nil)
            file_contents = fetch_file_contents(context, web_page_id)
            response = llama_bot_completion(user_message, context, file_contents, selected_element, web_page_id)
            message_to_user = response['message']
            handle_decision!(response)
            return message_to_user
        end

        def handle_decision!(response)
            Rails.logger.info("RESPONSE: #{response}")
            Rails.logger.info("DECISION: #{response['decision']}")
            case response['decision']
            when "IMPROVE_DESIGN"
                handle_improve_design(response)
            when "GENERATE_SCAFFOLD_COMMAND"
                handle_scaffold_command(response)
            end
        end

        def handle_improve_design(response)
            improved_html = response['message']
            web_page = Page.find_by(id: response['query_params']['web_page_id'])
            web_page.update(content: improved_html)
            return "Got it! Here is the improved design you asked for: #{improved_html}. Refresh your browser to see the new design."
        end        

        def handle_scaffold_command(response)
            scaffold_command = response['message']
            Rails.logger.info("SCAFFOLD COMMAND!: #{scaffold_command}")
      
            # Execute the scaffold command
            scaffold_command = scaffold_command.gsub("scaffold", "llama_scaffold")
            output = ""
            IO.popen(scaffold_command) do |io|
              output = io.read
            end
            
            Rails.logger.info("SCAFFOLD OUTPUT!: #{output}")
            
            Rails.logger.info("Now, need to run rails db:migrate! #{output}")
            
            output = ""
            IO.popen("rails db:migrate") do |io|
              output = io.read
            end
      
            return "Got it! Here is the scaffold command you need to run in your terminal: #{scaffold_command}. I ran the scaffold command for you. Here is the output from the terminal: #{output}. Refresh your browser to see the new page on the left navbar."
        end

        private

        def llama_bot_completion(user_message, context=nil, file_contents=nil, selected_element=nil, web_page_id=nil)
            params = {
                'user_message' => user_message,
                'context' => context,
                'selected_element' => selected_element,
                'web_page_id' => web_page_id,
                'file_contents' => file_contents
            }.compact
            
            response = JSON.parse(make_post_request("#{ENV['LLAMA_BOT_URI']}/completion", params))
            return response
        end

        # Make a POST request to the LlamaBot API
        def make_post_request(base_url, params)
            uri = URI.parse(base_url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = uri.scheme == 'https'
            
            request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
            request.body = params.to_json
            
            response = http.request(request)
            response.body
        end

        # Fetch the relevent file contents from the database or the file system
        def fetch_file_contents(context, web_page_id=nil)
            file_path = context || "app/views/llama_bot/home.html.erb"

            should_we_edit_html_in_webpage_database = file_path.include?("pages/show") && !web_page_id&.empty?
            @web_page = web_page_id&.empty? ? nil : Page.find_by(id: web_page_id)
            
            # Load the HTML content from the database or the file system
            file_contents = should_we_edit_html_in_webpage_database ? @web_page&.content : File.read(file_path)

            return file_contents
        end
    end
end