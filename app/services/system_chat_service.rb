# app/services/system_chat_service.rb
class SystemChatService
    def self.process_message(user, message)
      response = # generate response based on the message
      ChatChannel.broadcast_to(user, { message: response })
    end
  end