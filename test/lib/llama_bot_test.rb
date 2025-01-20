# require 'test_helper'
# require 'mocha/minitest'
# require_relative '../../lib/llama_bot'

# class LlamaBotTest < ActiveSupport::TestCase
#   def setup
#     @user_message = "Hello, LlamaBot!"
#     @context = "app/views/llama_bot/home.html.erb"
#     @file_contents = "<h1>Welcome to LlamaBot</h1>"
#     # @web_page_id = pages(:one).id
#     @web_page_id = "123"
#   end

#   test "completion returns message to user" do
#     mock_response = {
#       'message' => "Hello, human!",
#       'decision' => "RESPOND",
#       'action' => "RESPOND",
#       'payload' => {}
#     }

#     LlamaBot.expects(:fetch_file_contents).returns(@file_contents)
#     LlamaBot.expects(:llama_bot_completion).returns(mock_response)

#     result = LlamaBot.completion(@user_message, @context)
#     assert_equal "Hello, human!", result
#   end

#   test "handle_write_code updates database when editing webpage" do
#     mock_response = {
#       'action' => "WRITE_CODE",
#       'payload' => {
#         'code' => "<h1>Updated LlamaBot Page</h1>",
#         'destination' => "pages/show"
#       },
#       'query_params' => {
#         'context' => "pages/show",
#         'web_page_id' => @web_page_id,
#         'user_message' => "Update the heading"
#       }
#     }

#     mock_page = mock()
#     mock_page.expects(:update).with(content: "<h1>Updated LlamaBot Page</h1>")
#     mock_page.expects(:id).returns(@web_page_id)
#     Page.expects(:find_by).with(id: @web_page_id).returns(mock_page)
#     PageHistory.expects(:create).with(
#       page_id: @web_page_id,
#       content: "<h1>Updated LlamaBot Page</h1>",
#       prompt: "Update the heading",
#       user_message: "Update the heading"
#     )

#     result = LlamaBot.handle_write_code(mock_response)
#     assert_match /Got it! Here is the code you asked for:/, result
#   end

#   test "handle_write_code rejects in sandbox mode" do
#     ENV['SANDBOX_MODE'] = "true"
#     mock_response = {
#       'action' => "WRITE_CODE",
#       'payload' => {
#         'code' => "puts 'Hello, World!'",
#         'destination' => "test.rb"
#       },
#       'query_params' => {
#         'context' => "some_context",
#         'user_message' => "Write a Hello World program"
#       }
#     }

#     result = LlamaBot.handle_write_code(mock_response)
#     assert_equal "Sorry, but we're in sandbox mode. You can't write code to the filesystem in sandbox mode.", result
#   end

#   test "handle_run_commands executes commands and returns output" do
#     ENV['SANDBOX_MODE'] = 'false'
#     mock_response = {
#       'action' => "RUN_COMMANDS",
#       'payload' => {
#         'commands' => ["echo 'Hello from LlamaBot'"]
#       }
#     }

#     IO.expects(:popen).yields(StringIO.new("Hello from LlamaBot\n"))

#     result = LlamaBot.handle_run_commands(mock_response)
#     assert_match /Got it! Here is the command you asked for:/, result
#     assert_match /Here is the output from the terminal: Hello from LlamaBot/, result
#   end

#   test "handle_run_commands rejects in sandbox mode" do
#     ENV['SANDBOX_MODE'] = 'true'
#     mock_response = {
#       'action' => "RUN_COMMANDS",
#       'payload' => {
#         'commands' => ["echo 'Hello from LlamaBot'"]
#       }
#     }

#     result = LlamaBot.handle_run_commands(mock_response)
#     assert_equal "Sorry, but we're in sandbox mode. You can't run commands in sandbox mode.", result
#   end

#   test "llama_bot_completion makes API request and returns parsed response" do
#     mock_api_response = {
#       'message' => "API response",
#       'decision' => "RESPOND",
#       'action' => "RESPOND",
#       'payload' => {}
#     }.to_json

#     LlamaBot.expects(:make_post_request).returns(mock_api_response)

#     result = LlamaBot.send(:llama_bot_completion, @user_message, @context, @file_contents)
#     assert_equal JSON.parse(mock_api_response), result
#   end

#   test "fetch_file_contents reads from database for web pages" do
#     mock_page = mock()
#     mock_page.expects(:content).returns("<h1>Web Page Content</h1>")
#     Page.expects(:find_by).with(id: @web_page_id).returns(mock_page)

#     result = LlamaBot.send(:fetch_file_contents, "pages/show", @web_page_id)
#     assert_equal "<h1>Web Page Content</h1>", result
#   end

#   test "fetch_file_contents reads from file system for other contexts" do
#     File.expects(:read).with(@context).returns(@file_contents)

#     result = LlamaBot.send(:fetch_file_contents, @context)
#     assert_equal @file_contents, result
#   end
# end