class ChatsController < ApplicationController
  def index
    @chat_users = ChatUser.includes(chat: :chat_users).where(external_key: params[:external_key])
  end
end
