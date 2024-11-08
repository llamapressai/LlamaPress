# lib/tasks/websocket.rake
namespace :websocket do
    desc 'Start WebSocket client with Rails environment'
    task monitor: :environment do
        require 'async'
        require 'async/websocket/client'
        require 'json'
        require 'logger'
        require 'timeout'
        
        # Set up a logger to capture detailed output
        logger = Logger.new(STDOUT)
        logger.level = Logger::DEBUG
        
        Async do
          begin
            # Add connection timeout
            Timeout.timeout(120) do
                uri = URI(ENV['LLAMABOT_WEBSOCKET_URL'])
                uri.scheme = 'wss'
                endpoint = Async::HTTP::Endpoint.new(
                uri,
                ssl_context: OpenSSL::SSL::SSLContext.new.tap do |ctx|
                    ctx.verify_mode = OpenSSL::SSL::VERIFY_PEER
                    
                    # Use system certificates from macOS
                    # ctx.ca_path = '/etc/ssl/certs'  # Try this first
                    # If the above doesn't work, try these alternatives:
                    # ctx.ca_file = '/usr/local/etc/openssl/cert.pem'  # Homebrew OpenSSL
                    # ctx.ca_file = '/usr/local/etc/ca-certificates/cert.pem'
                    
                    # Certificate and key setup
                    # ctx.cert = OpenSSL::X509::Certificate.new(File.read(File.expand_path('~/.ssl/llamapress/cert.pem')))
                    # ctx.key = OpenSSL::PKey::RSA.new(File.read(File.expand_path('~/.ssl/llamapress/key.pem')))
                end
                )

              
              # Add connection options for debugging
              options = {
                headers: {
                  'User-Agent' => 'Ruby WebSocket Client/1.0'
                },
                timeout: 5  # Connection timeout in seconds
              }
              
              Async::WebSocket::Client.connect(endpoint) do |connection|
                logger.info "WebSocket connection opened"
                # Set up ping/pong handling
                # connection.on(:pong) do |data|
                #   logger.info "Received pong: #{data}"
                # end
                
                # Send initial ping with message ID
                message = {
                  type: "ping",
                  id: Time.now.to_i
                }
                logger.info "Sending message: #{message}"
                connection.write(message.to_json)
                
                # Add message timeout
                start_time = Time.now
                timeout = 30  # seconds
                
                # Read messages with timeout
                while Time.now - start_time < timeout
                  message = connection.read
                  break unless message
                  
                  logger.info "Received message: #{message}"
                  parsed_message = JSON.parse(message) rescue nil
                  
                  if parsed_message && parsed_message['type'] == 'pong'
                    logger.info "Received valid pong response"
                    break
                  end
                end
                
                if Time.now - start_time >= timeout
                  logger.error "Timeout waiting for response"
                end
                
                # connection.close
                logger.info "Connection closed normally"
              end
            end
          rescue Timeout::Error => e
            logger.error "Connection timeout: #{e.message}"
          rescue Async::WebSocket::ConnectionError => e
            logger.error "WebSocket connection error: #{e.message}"
          rescue => e
            logger.error "Unexpected error: #{e.message}"
            logger.error e.backtrace.join("\n")
          end
        end
    end
  
    desc 'Start WebSocket client in debug mode'
    task debug: :environment do
      Rails.logger.level = Logger::DEBUG
      Rake::Task['websocket:monitor'].invoke
    end
  end