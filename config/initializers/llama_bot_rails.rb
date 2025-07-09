Rails.application.configure do
  config.llama_bot_rails.websocket_url      = ENV.fetch("LLAMABOT_WEBSOCKET_URL", "ws://localhost:8000/ws")
  config.llama_bot_rails.llamabot_api_url   = ENV.fetch("LLAMABOT_API_URL", "http://localhost:8000")
  config.llama_bot_rails.enable_console_tool = !Rails.env.production?

  # ------------------------------------------------------------------------
  # Custom State Builder
  # ------------------------------------------------------------------------
  # The gem uses `LlamaBotRails::AgentStateBuilder` by default.
  # Uncomment this line to use the builder in app/llama_bot/
  #
  config.llama_bot_rails.state_builder_class = "LlamaPress::AgentStateBuilder"
end
