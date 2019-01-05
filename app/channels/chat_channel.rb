class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{current_user.id}"
    current_user.appear
  end

  def unsubscribed
    current_user.disappear
  end
end
