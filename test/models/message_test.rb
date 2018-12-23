require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test "get messages for two users by their external keys" do
    chat = ChatUser
               .where(external_key: [
                   chat_users(:john).external_key,
                   chat_users(:maria).external_key
               ])
               .select(:chat_id)
               .group(:chat_id)
               .having("count(*) = 2")[0].chat

    assert_equal 2, chat.messages.count
    Message.create(body: 'Good evening', chat: chat, external_key: chat_users(:maria).external_key)
    assert_equal 3, chat.messages.reload.count
    Message.create(body: 'Good bye', chat: chat, external_key: chat_users(:ron).external_key)
    assert_equal 3, chat.messages.reload.count
  end
end
