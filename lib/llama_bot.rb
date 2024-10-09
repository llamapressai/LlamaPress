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
            should_we_write_page_to_database = response["query_params"]["context"].include? "pages/show"
            
            # Check if the response contains snippets
            doc = Nokogiri::HTML.fragment(code_to_write)
            snippet_elements = doc.css('[data-llama-snippet-id]')
          
            if snippet_elements.any?
              snippet_elements.each do |snippet_element|
                snippet_id = snippet_element['data-llama-snippet-id']
                snippet_content = snippet_element.to_html
          
                # Update the snippet in the database if it exists
                snippet = Snippet.find_by(id: snippet_id)
                if snippet
                  snippet.update(content: snippet_content)
                else
                  return "Snippet with ID #{snippet_id} not found."
                end
              end
            end
          
            if should_we_write_page_to_database
              # Write the full page content to the database
              web_page = Page.find_by(id: response['query_params']['web_page_id'])
              if web_page
                web_page.update(content: code_to_write)
                PageHistory.create(
                  page_id: web_page.id, 
                  content: code_to_write, 
                  prompt: response['query_params']['user_message'], 
                  user_message: response['query_params']['user_message']
                )
              else
                return "Web page not found."
              end
            elsif ENV['SANDBOX_MODE'] == 'true'
              # If in sandbox mode, reject file write
              return "Sorry, but we're in sandbox mode. You can't write code to the filesystem in sandbox mode."
            else
              # Write the code to the specified file destination
              File.write(destination, code_to_write)
            end
          
            return "Got it! Snippets have been updated and here is the code you asked for: #{code_to_write}. Refresh your browser to see the new code."
          end
          

        def handle_run_commands(response)
            # if we're in sandbox mode, reject.
            if ENV['SANDBOX_MODE'] == 'true'
                return "Sorry, but we're in sandbox mode. You can't run commands in sandbox mode."
            end
            commands_to_run = response['payload']['commands']
            output = ""
            commands_to_run.each do |command|
                IO.popen(command) do |io|
                    output = io.read
                end
            end
            return "Got it! Here is the command you asked for: #{commands_to_run}. Here is the output from the terminal: #{output}."
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
                        
            begin
                response = JSON.parse(make_post_request("#{ENV['LLAMABOT_API_URL']}/completion", params))
            rescue JSON::ParserError => e
                Rails.logger.error("JSON parsing error: #{e.message}")
                return { 'error' => 'Invalid JSON response from LlamaBot API' }
            end
             return response
        end

        # Make a POST request to the LlamaBot API
        def make_post_request(base_url, params)
            uri = URI.parse(base_url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.open_timeout = 10  # seconds
            http.read_timeout = 600 # seconds (increase as needed)
            http.use_ssl = uri.scheme == 'https'
            
            request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
            request.body = params.to_json
            
            begin
                response = http.request(request)
                
                case response
                when Net::HTTPSuccess
                    response.body
                else
                    Rails.logger.error("LlamaBot API error: #{response.code} - #{response.message}")
                    Rails.logger.error("Response body: #{response.body}")
                    raise "LlamaBot API error: #{response.code} - #{response.message}"
                end
            rescue StandardError => e
                Rails.logger.error("Error making request to LlamaBot API: #{e.message}")
                raise "Failed to communicate with LlamaBot API: #{e.message}"
            end
        end

        # Fetch the relevent file contents from the database or the file system
        def fetch_file_contents(context, web_page_id=nil)
            file_path = context || "app/views/llama_bot/home.html.erb"

            should_we_edit_html_in_webpage_database = file_path.include?("pages/show") && !web_page_id&.empty?
            @web_page = web_page_id&.empty? ? nil : Page.find_by(id: web_page_id)
            
            # Load the HTML content from the database or the file system
            file_contents = should_we_edit_html_in_webpage_database ? @web_page&.render_content : File.read(file_path)

            return file_contents
        end
    end
end