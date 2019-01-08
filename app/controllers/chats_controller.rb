class ChatsController < ApplicationController
  def index
    @chat_users = ChatUser
                      .includes(chat: {chat_users: :user})
                      .where(user: current_user)
  end
end
