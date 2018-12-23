require 'test_helper'

class ChatUserTest < ActiveSupport::TestCase
  test "check existing of chat" do
    assert_equal ChatUser
                     .where(external_key: [
                         chat_users(:john).external_key,
                         chat_users(:maria).external_key
                     ])
                     .select(:chat_id)
                     .group(:chat_id)
                     .having("count(*) = 2")[0].chat_id, chats(:one).id

    assert_equal ChatUser
                     .where(external_key: [
                         chat_users(:ron).external_key,
                         chat_users(:maria).external_key
                     ])
                     .select(:chat_id)
                     .group(:chat_id)
                     .having("count(*) = 2"), []
  end
end
