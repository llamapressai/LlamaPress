# llamabot_extensions/wordpress_extension.rb
require 'wordpress'
class WordpressExtension < LlamaBotExtension
    # Optional: Override this in subclasses to provide metadata
    def self.metadata
      {
        name: "Wordpress for LlamaBot",
        description: "A Wordpress extension for LlamaBot.",
        conditions: "Use this extension when the user asks to update a Wordpress page or post."
      }
    end
  
    # Method to be implemented by subclasses
    def self.run(context)
        #TODO: This is where we'll take the map that the LLM created, and send it in to update the Cornerstone page.
        # Access WordPress Client..?
        # How do we know the domain URL?
        # How do we know the Page Number?
        # Does LlamaBot tell us that?

      raise NotImplementedError, "Subclasses must implement the `run` method"
    end
  
    # Helper: Validate context (optional)
    def self.validate_context(context)
      raise ArgumentError, "Context must be a hash" unless context.is_a?(Hash)
    end
  
    # Helper: Log actions (optional)
    def self.log(message)
      Rails.logger.info("[LlamaBot Extension] #{message}")
    end
  end