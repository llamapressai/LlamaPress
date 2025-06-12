require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Add GCPLogger module here
require "google/cloud/logging"

module GCPLogger
  class CustomLogger < Logger
    def initialize
      @level = Logger::DEBUG
      
      # Initialize Google Cloud Logging client
      @logging = Google::Cloud::Logging.new(
        project: ENV['GOOGLE_CLOUD_PROJECT'],
        credentials: ENV['GOOGLE_APPLICATION_CREDENTIALS'] 
      )
      
      # Set the log name and resource type
      @log_name = "rails-app-logs"
      @resource_type = "global"
    end
    
    # Map standard Logger severity levels to GCP severity
    SEVERITY_MAP = {
      "DEBUG" => "DEBUG",
      "INFO" => "INFO", 
      "WARN" => "WARNING",
      "ERROR" => "ERROR",
      "FATAL" => "CRITICAL",
      "UNKNOWN" => "DEFAULT"
    }
    
    def add(severity, message = nil, progname = nil)
      severity_label = Logger::SEV_LABEL[severity] || "UNKNOWN"
      gcp_severity = SEVERITY_MAP[severity_label] || "DEFAULT"
      
      # Extract message from block if given
      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
        end
      end
      
      begin
        # Create the log entry
        entry = @logging.entry
        entry.payload = message
        entry.log_name = @log_name
        entry.severity = gcp_severity
        entry.resource.type = @resource_type
        
        # Write the entry
        @logging.write_entries entry
      rescue => e
        puts "Failed to log to Google Cloud: #{e.message}"
      end
      
      true # Return true as Logger expects
    end
  end
  
  # Helper method to get a configured instance
  def self.logger
    @logger ||= CustomLogger.new
  end
  
  def self.test
    logger = self.logger
    logger.debug "GCP Debug Test Message"
    logger.info "GCP Info Test Message"
    logger.warn "GCP Warning Test Message"
    logger.error "GCP Error Test Message"
    logger.fatal "GCP Fatal Test Message"
    
    # Test with structured data
    logger.info({
      event: "log_test",
      timestamp: Time.now.iso8601,
      source: "GCPLogger.test"
    })
  end
end

module LlamaPress
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Add the app/instruments directory to the autoload paths - used for mixpanel instrumentation
    config.autoload_paths << Rails.root.join('app', 'instruments').to_s
    config.action_view.annotate_rendered_view_with_filenames = false
    config.active_record.verify_foreign_keys_for_fixtures = false



    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Load the local environment variables
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exist?(env_file)
    end  
  end
end
