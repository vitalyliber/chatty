module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include ApplicationHelper
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      logger.debug 'Connection debug info:'
      logger.debug "Bearer: #{cookies[:bearer]}"
      user = auth(cookies[:bearer])
      if user.present?
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end
