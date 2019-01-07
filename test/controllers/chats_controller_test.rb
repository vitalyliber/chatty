require 'test_helper'

class ChatsControllerTest < ActionDispatch::IntegrationTest
  test "should get chats" do
    Chat.destroy_all
    populate = ->(n) {n.times do |el|
      user = User.create!(
          external_key: "user_#{el}",
          name: "user_#{el}",
          avatar_url: 'https://api-server.com/image.jpg'
      )
      Chat.create!(chat_users: [
          ChatUser.new(external_key: "user_#{el}", user: user),
          ChatUser.new(external_key: 'john', user: User.find_or_create_by(external_key: 'john'))
      ])
    end}

    assert_perform_constant_number_of_queries(
        populate: populate,
        scale_factors: [2, 5, 10]
    ) do
      get chats_path,
          headers: {
              Authorization: 'Bearer johnBearer'
          }
    end
    assert_response :success
    assert_equal JSON.parse(body)['chats'].count, 10
  end

end
