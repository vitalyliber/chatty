require 'test_helper'

class ChatsControllerTest < ActionDispatch::IntegrationTest
  test "should get chats" do
    Chat.destroy_all
    Chat.all
    populate = ->(n) {n.times do |el|
      Chat.create!(chat_users: [
          ChatUser.new(external_key: "user_#{el}"),
          ChatUser.new(external_key: 'john')
      ])
    end}

    assert_perform_constant_number_of_queries(
        populate: populate,
        scale_factors: [2, 5, 10]
    ) do
      get chats_path, params: { external_key: 'john' }
    end
    assert_response :success
    assert_equal JSON.parse(body)['chats'].count, 10
  end

end
