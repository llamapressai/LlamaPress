Rails.application.configure do
  config.llama_bot_rails.websocket_url = ENV.fetch("LLAMABOT_WEBSOCKET_URL", "ws://localhost:8000/ws")
  config.llama_bot_rails.llamabot_api_url = ENV.fetch("LLAMABOT_API_URL", "http://localhost:8000")
  config.llama_bot_rails.enable_console_tool = !Rails.env.production?
end
