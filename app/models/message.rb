class Message < ApplicationRecord
  belongs_to :chat, touch: true
  belongs_to :user
  validates_presence_of :chat, :body
  validate :must_connect_to_existing_chat_user
  after_create :raise_unread_count, :send_notifications

  private

  def must_connect_to_existing_chat_user
    unless chat.chat_users.exists?(user: user)
      errors.add(:external_key, "can't be from not existing chat user")
    end
  end

  def raise_unread_count
    chat_user = chat.chat_users.where.not(user: user).first
    chat_user.unread_count += 1
    chat_user.save!
  end

  def send_notifications
    opponent = chat.opponent(user.id)
    me = chat.me(user.id)
    message = {
        sender_external_key: user.external_key,
        recepient_external_key: opponent.user.external_key,
        updated_at: updated_at.iso8601,
        body: body,
    }
    # receiver should put the message to a chat messages list
    chat_updated_at = chat.try(:updated_at).iso8601
    chat = {
        unread_count: opponent.unread_count,
        updated_at: chat_updated_at,
        name: me.user.name,
        avatar_url: me.user.avatar_url,
        external_key: user.external_key, # what chat user should be updated?
    }
    # opponent should update the chat element in a chats list
    ActionCable.server.broadcast "chat_#{opponent.user.external_key}", {
        chat: chat,
        message: message
    }
  end
end
