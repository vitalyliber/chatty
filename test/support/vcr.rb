require "vcr"
# https://gist.github.com/mattbrictson/72910465f36be8319cde

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = File.expand_path("../../cassettes", __FILE__)
  config.hook_into :webmock
  config.ignore_request { ENV["DISABLE_VCR"] }
  config.ignore_localhost = true
  config.default_cassette_options = {
      :record => :new_episodes
  }
end

# Monkey patch the `test` DSL to enable VCR and configure a cassette named
# based on the test method. This means that a test written like this:
#
# class OrderTest < ActiveSupport::TestCase
#   test "user can place order" do
#     ...
#   end
# end
#
# will automatically use VCR to intercept and record/play back any external
# HTTP requests using `cassettes/order_test/_user_can_place_order.yml`.
#
class ActiveSupport::TestCase
  def self.test(test_name, &block)
    return super if block.nil?

    cassette = [name, test_name].map do |str|
      str.underscore.gsub(/[^A-Z]+/i, "_")
    end.join("/")

    super(test_name) do
      VCR.use_cassette(cassette) do
        instance_eval(&block)
      end
    end
  end
end