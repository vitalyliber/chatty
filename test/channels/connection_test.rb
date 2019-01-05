require 'test_helper'

module ApplicationCable
  class ConnectionTest < ActionCable::Connection::TestCase
    test 'test_connects_with_cookies with not existing user' do
      # Simulate a connection
      connect cookies: { bearer: 'mishaBearer' }

      # Asserts that the connection identifier is correct
      user = User.last
      assert_equal user, connection.current_user
    end

    test 'test_connects_with_cookies with existing user' do
      # Simulate a connection
      connect cookies: { bearer: 'johnBearer' }

      # Asserts that the connection identifier is correct
      user = User.last
      assert_equal users(:john), connection.current_user
    end

    test 'test_does_not_connect_without_user' do
      assert_reject_connection do
        connect
      end
    end
  end
end