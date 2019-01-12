require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include ActionCable::TestHelper

  test "should get index" do
    get messages_path,
        params: {
            chat: {
                recipient_external_key: 'john'
            }
        },
        headers: {
            Authorization: 'Bearer mariaBearer'
        }
    assert_response :success
    assert_equal 2, JSON.parse(body)['messages'].count
  end

  test "should not create for the same user" do
    get messages_path,
        params: {
            chat: {
                recipient_external_key: 'jessy'
            }
        },
        headers: {
            Authorization: 'Bearer jessyBearer'
        }
    assert_response :bad_request
  end

  test "should create new chat and message" do
    assert_equal 3, Chat.count
    assert_equal 3, ChatUser.count
    assert_equal 3, Message.count
    assert_equal 3, User.count
    assert_broadcasts "chat_alice", 0
    assert_broadcasts "chat_jessy", 0
    post messages_path,
         params: {
             message: {
                 body: 'Hello'
             },
             chat: {
                 recipient_external_key: 'alice'
             }
         },
         headers: {
             Authorization: 'Bearer jessyBearer'
         }
    assert_response :success
    assert User.find_by(external_key: 'alice').present?
    assert_broadcasts "chat_alice", 1
    assert_broadcasts "chat_jessy", 0
    assert_equal 4, Chat.count
    assert_equal 5, ChatUser.count
    assert_equal 4, Message.count
    assert_equal 5, User.count
  end

  test "should create new message for existing chat" do
    chat = find_chat_by_users([users(:maria), users(:john)])
    chat_updated_at = chat.updated_at
    assert_equal 3, Chat.count
    assert_equal 3, ChatUser.count
    assert_equal 3, Message.count
    assert_broadcasts "chat_maria", 0
    assert_broadcasts "chat_john", 0
    msg = 'Hello'
    post messages_path,
         params: {
             message: {
                 body: msg
             },
             chat: {
                 recipient_external_key: users(:maria).external_key
             }
         },
         headers: {
             Authorization: 'Bearer johnBearer'
         }
    assert_response :success
    assert_equal JSON.parse(body), {"message" => {"id" => Message.last.id}}
    assert_broadcasts "chat_maria", 1
    assert_broadcasts "chat_john", 0
    assert_broadcast_on "chat_maria", {
        chat: {
            unread_count: chat_users(:maria).unread_count,
            updated_at: chat.reload.updated_at.iso8601,
            name: 'John',
            avatar_url: users(:john).avatar_url,
            external_key: users(:john).external_key,
        },
        message: {
            sender_external_key: users(:john).external_key,
            recepient_external_key: users(:maria).external_key,
            updated_at: Message.last.updated_at.iso8601,
            body: msg,
        }
    }
    assert_not_equal chat_updated_at, chat.updated_at
    assert_equal 3, Chat.count
    assert_equal 3, ChatUser.count
    assert_equal 4, Message.count
  end

  test "read messages" do
    assert_equal chat_users(:maria).unread_count, 1
    assert_equal chat_users(:john).unread_count, 0
    put read_messages_path,
        params: {
            chat: {
                recipient_external_key: users(:john).external_key
            }
        },
        headers: {
            Authorization: 'Bearer mariaBearer'
        }
    assert_response :success
    assert_equal chat_users(:maria).reload.unread_count, 0
    assert_equal chat_users(:john).unread_count, 0
  end

end
