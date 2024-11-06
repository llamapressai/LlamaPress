module ApplicationCable
  class ChatChannel < ApplicationCable::Channel
    def subscribed
      stream_from "chat_channel_#{params[:session_id]}"
    end
  
    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end
  end
end