require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get messages_path,
        params: {
            chat: {
                sender_external_key: 'maria',
                recipient_external_key: 'john'
            }
        }
    assert_response :success
    assert_equal 2, JSON.parse(body)['messages'].count
  end

  test "should not create for the same user" do
    get messages_path,
        params: {
            chat: {
                sender_external_key: 'jessy',
                recipient_external_key: 'jessy'
            }
        }
    assert_response :bad_request
  end

  test "should create new chat and message" do
    assert_equal 3, Chat.count
    assert_equal 3, Message.count
    post messages_path,
         params: {
             message: {
                 body: 'Hello'
             },
             chat: {
                 sender_external_key: 'jessy',
                 recipient_external_key: 'alice'
             }
         }
    assert_response :success
    assert_equal 4, Chat.count
    assert_equal 4, Message.count
  end

  test "should create new message for existing chat" do
    assert_equal 3, Chat.count
    assert_equal 3, Message.count
    post messages_path,
         params: {
             message: {
                 body: 'Hello'
             },
             chat: {
                 sender_external_key: chat_users(:john).external_key,
                 recipient_external_key: chat_users(:maria).external_key
             }
         }
    assert_response :success
    assert_equal 3, Chat.count
    assert_equal 4, Message.count
  end

end
