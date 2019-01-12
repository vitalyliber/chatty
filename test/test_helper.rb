ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
# Load vcr from test/support
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |rb| require(rb) }
require "n_plus_one_control/minitest"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def find_chat_by_users(users)
    ChatUser
        .where(user: users)
        .select(:chat_id)
        .group(:chat_id)
        .having("count(*) = 2")[0].chat
  end
end
