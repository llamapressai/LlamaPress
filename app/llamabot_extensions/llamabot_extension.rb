# llamabot_extensions/base_extension.rb
class LlamaBotExtension
    # Optional: Override this in subclasses to provide metadata
    def self.metadata
      {
        name: "Base Extension",
        description: "A base class for all LlamaBot extensions.",
        conditions: "Define when this extension should be used."
      }
    end
  
    # Method to be implemented by subclasses
    def self.run(context)
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
  