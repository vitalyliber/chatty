require 'test_helper'

class ChatUserTest < ActiveSupport::TestCase
  test "check existing of chat" do
    assert_equal ChatUser
                     .where(user: [
                         users(:john),
                         users(:maria)
                     ])
                     .select(:chat_id)
                     .group(:chat_id)
                     .having("count(*) = 2")[0].chat_id, chats(:one).id

    assert_equal ChatUser
                     .where(user: [
                         users(:ron),
                         users(:maria)
                     ])
                     .select(:chat_id)
                     .group(:chat_id)
                     .having("count(*) = 2"), []
  end
end
