require "test_helper"

class LlamaBotRailsConfigTest < ActiveSupport::TestCase
  test "should have correct websocket_url configuration" do
    expected_url = "ws://llamabot-backend:8000/ws"
    actual_url = Rails.application.config.llama_bot_rails.websocket_url
    
    assert_equal expected_url, actual_url, 
      "WebSocket URL should be configured for Docker networking"
  end

  test "should have correct llamabot_api_url configuration" do
    expected_url = "http://llamabot-backend:8000"
    actual_url = Rails.application.config.llama_bot_rails.llamabot_api_url
    
    assert_equal expected_url, actual_url, 
      "API URL should be configured for Docker networking"
  end

  test "should have enable_console_tool configured" do
    assert_not_nil Rails.application.config.llama_bot_rails.enable_console_tool, 
      "enable_console_tool should be configured"
  end

  test "should respect environment variable overrides" do
    original_websocket_url = ENV["LLAMABOT_WEBSOCKET_URL"]
    original_api_url = ENV["LLAMABOT_API_URL"]
    
    begin
      ENV["LLAMABOT_WEBSOCKET_URL"] = "ws://custom-backend:9000/ws"
      ENV["LLAMABOT_API_URL"] = "http://custom-backend:9000"
      
      # Reload the configuration
      Rails.application.config.llama_bot_rails.websocket_url = 
        ENV.fetch("LLAMABOT_WEBSOCKET_URL", "ws://llamabot-backend:8000/ws")
      Rails.application.config.llama_bot_rails.llamabot_api_url = 
        ENV.fetch("LLAMABOT_API_URL", "http://llamabot-backend:8000")
      
      assert_equal "ws://custom-backend:9000/ws", 
        Rails.application.config.llama_bot_rails.websocket_url,
        "Should use environment variable for websocket URL"
      
      assert_equal "http://custom-backend:9000", 
        Rails.application.config.llama_bot_rails.llamabot_api_url,
        "Should use environment variable for API URL"
    ensure
      # Restore original values
      if original_websocket_url
        ENV["LLAMABOT_WEBSOCKET_URL"] = original_websocket_url
      else
        ENV.delete("LLAMABOT_WEBSOCKET_URL")
      end
      
      if original_api_url
        ENV["LLAMABOT_API_URL"] = original_api_url
      else
        ENV.delete("LLAMABOT_API_URL")
      end
      
      # Restore default configuration
      Rails.application.config.llama_bot_rails.websocket_url = 
        ENV.fetch("LLAMABOT_WEBSOCKET_URL", "ws://llamabot-backend:8000/ws")
      Rails.application.config.llama_bot_rails.llamabot_api_url = 
        ENV.fetch("LLAMABOT_API_URL", "http://llamabot-backend:8000")
    end
  end

  test "should use Docker networking URLs by default" do
    # These are the new default values after the change
    assert_match /llamabot-backend/, Rails.application.config.llama_bot_rails.websocket_url,
      "WebSocket URL should use Docker networking hostname"
    
    assert_match /llamabot-backend/, Rails.application.config.llama_bot_rails.llamabot_api_url,
      "API URL should use Docker networking hostname"
  end

  test "should not use localhost URLs" do
    # These are the old values that should not be used anymore
    refute_match /localhost/, Rails.application.config.llama_bot_rails.websocket_url,
      "WebSocket URL should not use localhost"
    
    refute_match /localhost/, Rails.application.config.llama_bot_rails.llamabot_api_url,
      "API URL should not use localhost"
  end

  test "should use correct ports" do
    assert_match /:8000/, Rails.application.config.llama_bot_rails.websocket_url,
      "WebSocket URL should use port 8000"
    
    assert_match /:8000/, Rails.application.config.llama_bot_rails.llamabot_api_url,
      "API URL should use port 8000"
  end

  test "should use correct WebSocket path" do
    assert_match /\/ws$/, Rails.application.config.llama_bot_rails.websocket_url,
      "WebSocket URL should end with /ws"
  end

  test "should use ws protocol for WebSocket" do
    assert_match /^ws:\/\//, Rails.application.config.llama_bot_rails.websocket_url,
      "WebSocket URL should use ws:// protocol"
  end

  test "should use http protocol for API" do
    assert_match /^http:\/\//, Rails.application.config.llama_bot_rails.llamabot_api_url,
      "API URL should use http:// protocol"
  end
end 