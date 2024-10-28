# app/channels/application_cable/connection.rb
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      if verified_user = env['warden'].user 
        logger.info "Verified user found: #{verified_user.email}"
        verified_user
      else
        logger.warn "No verified user found, rejecting connection"
        reject_unauthorized_connection
      end
    end
  end
end
