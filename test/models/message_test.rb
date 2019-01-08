require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  test "get messages for two users by their external keys" do
    chat = ChatUser
               .where(user: [
                   users(:john),
                   users(:maria)
               ])
               .select(:chat_id)
               .group(:chat_id)
               .having("count(*) = 2")[0].chat

    assert_equal 2, chat.messages.count
    assert_equal 0, chat_users(:john).unread_count
    Message.create(body: 'Good evening', chat: chat, user: users(:maria))
    assert_equal 1, chat_users(:john).reload.unread_count
    assert_equal 3, chat.messages.reload.count
    Message.create(body: 'Good bye', chat: chat, user: users(:ron))
    assert_equal 3, chat.messages.reload.count
  end
end
