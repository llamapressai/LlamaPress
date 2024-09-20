require 'net/http'
require 'uri'
require 'json'

module LlamaBot
    class << self
        def completion(user_message, context=nil, selected_element=nil, web_page_id=nil)
            file_contents = fetch_file_contents(context, web_page_id)
            response = llama_bot_completion(user_message, context, file_contents, selected_element, web_page_id)
            message_to_user = response['message']
            handle_response!(response)
            return message_to_user
        end

        # Actions:
        # Writing code to the filesystem or database
        # Run commands in terminal
        # Respond naturally
        def handle_response!(response)
            Rails.logger.info("RESPONSE: #{response}")
            Rails.logger.info("DECISION: #{response['decision']}")
            Rails.logger.info("ACTION: #{response['action']}")
            Rails.logger.info("PAYLOAD: #{response['paylod']}")

            case response['action']
            when "WRITE_CODE"
                handle_write_code(response)
            when "RUN_COMMANDS"
                handle_run_commands(response)
            else 
                return response['message']
            end
        end

        def handle_write_code(response)
            code_to_write = response['payload']['code']
            destination = response['payload']['destination']
            should_we_write_page_to_database =  response["query_params"]["context"].include? "pages/show"
            
            if should_we_write_page_to_database
                web_page = Page.find_by(id: response['query_params']['web_page_id'])
                web_page.update(content: code_to_write)
            else
                File.write(destination, code_to_write)
            end

            return "Got it! Here is the code you asked for: #{code_to_write}. Refresh your browser to see the new code."
        end

        def handle_run_commands(response)
            commands_to_run = response['payload']
            output = ""
            commands_to_run.each do |command|
                IO.popen(command) do |io|
                    output = io.read
                end
            end
            return "Got it! Here is the command you asked for: #{command_to_run}. Here is the output from the terminal: #{output}."
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