module Twilio    
    require 'twilio-ruby'

    def Twilio.send_text(number, message, twilio_number = '') #if twilio number is blank, we will use the 'universal' twilio number defined in ENV.
        account_sid = ENV['TWILIO_SID']
        auth_token = ENV['TWILIO_AUTH']
        client = Twilio::REST::Client.new(account_sid, auth_token)
        twilio_number = ENV['TWILIO_NUMBER']

        client = Twilio::REST::Client.new(account_sid, auth_token)
        from = twilio_number
        to = number
        message_params = Hash.new
        message_params[:from] = from
        message_params[:to] = to
        message_params[:body] = message

        # client.messages.create( message_params )
        client.messages.create(
            from: from,
            to: to,
            body: message
            )
    end
end