require 'test_helper'

class ChatChannelTest < ActionCable::Channel::TestCase
  test "the truth" do
    user = User.first
    assert_not user.online
    stub_connection(current_user: user)

    # Simulate a subscription creation
    subscribe

    assert user.reload.online

    # Asserts that the subscription was successfully created
    assert subscription.confirmed?

    # Asserts that the channel subscribes connection to a stream
    assert_equal "chat_#{user.id}", streams.last

    # Asserts that the user was unsubscribed from a stream
    subscription.unsubscribe_from_channel
    assert_not user.reload.online
  end
end
