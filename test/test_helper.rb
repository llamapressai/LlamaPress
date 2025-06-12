ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'mocha/minitest'

# Load environment variables from local_env.yml
if File.exist?(Rails.root.join('config', 'local_env.yml'))
  YAML.load_file(Rails.root.join('config', 'local_env.yml')).each do |key, value|
    ENV[key.to_s] = value.to_s
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    setup do
      # Silence all logging in tests
      Rails.logger.level = Logger::ERROR # or Logger::FATAL for only the most severe errors
    end

    # Cleanup after each test
    def teardown
      super
      if ENV["ENABLE_GOOGLE_CLOUD_LOGGING"] == "true" && defined?(Google::Cloud::Logging)
        # Give async writer time to finish
        sleep(1)
        # Force GC to help clean up gRPC connections
        GC.start
        GC.compact if GC.respond_to?(:compact)
        # Wait a bit more for gRPC to clean up
        sleep(0.5)
      end
    end

    # Suppress gRPC warnings in test output
    def before_setup
      super
      if ENV["ENABLE_GOOGLE_CLOUD_LOGGING"] == "true"
        # Redirect STDERR temporarily during setup
        @original_stderr = $stderr
        $stderr = File.open(File::NULL, 'w')
      end
    end

    def after_teardown
      super
      if ENV["ENABLE_GOOGLE_CLOUD_LOGGING"] == "true"
        # Restore STDERR
        $stderr = @original_stderr
      end
    end
  end
end
