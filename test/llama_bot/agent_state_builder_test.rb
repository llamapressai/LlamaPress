require "test_helper"

class AgentStateBuilderTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @page = pages(:one)
    @context = {
      user: @user,
      api_token: "test-token"
    }
    @params = {
      "page_id" => @page.id.to_s,
      "selected_element" => "test-element"
    }
    @builder = AgentStateBuilder.new(params: @params, context: @context)
  end

  test "should build agent state with correct agent_name" do
    state = @builder.build
    
    assert_equal "llamapress", state[:agent_name], 
      "Agent name should be 'llamapress' by default"
  end

  test "should include api_token in agent state" do
    state = @builder.build
    
    assert_equal "test-token", state[:api_token], 
      "API token should be included in agent state"
  end

  test "should include page_id in agent state" do
    state = @builder.build
    
    assert_equal @page.id.to_s, state[:page_id], 
      "Page ID should be included in agent state"
  end

  test "should include selected_element in agent state" do
    state = @builder.build
    
    assert_equal "test-element", state[:selected_element], 
      "Selected element should be included in agent state"
  end

  test "should include agent_prompt in agent state" do
    state = @builder.build
    
    assert_equal LlamaBotRails.agent_prompt_text, state[:agent_prompt], 
      "Agent prompt should be included in agent state"
  end

  test "should include current_page_html in agent state" do
    state = @builder.build
    
    assert_not_nil state[:current_page_html], 
      "Current page HTML should be included in agent state"
  end

  test "should handle missing page_id gracefully" do
    builder = AgentStateBuilder.new(params: {}, context: @context)
    state = builder.build
    
    assert_not_nil state, "Should build state even without page_id"
    assert_nil state[:page_id], "Page ID should be nil when not provided"
  end

  test "should handle missing selected_element gracefully" do
    params_without_element = @params.except("selected_element")
    builder = AgentStateBuilder.new(params: params_without_element, context: @context)
    state = builder.build
    
    assert_not_nil state, "Should build state even without selected_element"
    assert_nil state[:selected_element], "Selected element should be nil when not provided"
  end

  test "should build complete agent state structure" do
    state = @builder.build
    
    # Check all expected keys are present
    expected_keys = [:api_token, :agent_prompt, :agent_name, :page_id, :current_page_html, :selected_element]
    expected_keys.each do |key|
      assert state.has_key?(key), "Agent state should include #{key}"
    end
  end

  test "should handle nil context gracefully" do
    builder = AgentStateBuilder.new(params: @params, context: nil)
    
    assert_raises(NoMethodError) do
      builder.build
    end
  end

  test "should handle nil params gracefully" do
    builder = AgentStateBuilder.new(params: nil, context: @context)
    
    assert_raises(NoMethodError) do
      builder.build
    end
  end

  test "should include message in agent state when provided" do
    params_with_message = @params.merge({"message" => "test message"})
    builder = AgentStateBuilder.new(params: params_with_message, context: @context)
    state = builder.build
    
    assert_equal "test message", state[:message], 
      "Message should be included in agent state when provided"
  end

  test "should include thread_id in agent state when provided" do
    params_with_thread = @params.merge({"thread_id" => "test-thread-123"})
    builder = AgentStateBuilder.new(params: params_with_thread, context: @context)
    state = builder.build
    
    assert_equal "test-thread-123", state[:thread_id], 
      "Thread ID should be included in agent state when provided"
  end
end 