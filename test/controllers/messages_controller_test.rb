require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
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
    assert_equal 4, Chat.count
    assert_equal 5, ChatUser.count
    assert_equal 4, Message.count
    assert_equal 5, User.count
  end

  test "should create new message for existing chat" do
    assert_equal 3, Chat.count
    assert_equal 3, ChatUser.count
    assert_equal 3, Message.count
    post messages_path,
         params: {
             message: {
                 body: 'Hello'
             },
             chat: {
                 recipient_external_key: chat_users(:maria).external_key
             }
         },
         headers: {
             Authorization: 'Bearer johnBearer'
         }
    assert_response :success
    assert_equal 3, Chat.count
    assert_equal 3, ChatUser.count
    assert_equal 4, Message.count
  end

end
