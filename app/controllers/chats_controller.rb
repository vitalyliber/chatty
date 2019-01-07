class ChatsController < ApplicationController
  def index
    @chat_users = ChatUser
                      .includes(chat: {chat_users: :user})
                      .where(external_key: current_user.external_key)
  end
end
