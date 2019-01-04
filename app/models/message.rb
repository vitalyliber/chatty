class Message < ApplicationRecord
  belongs_to :chat
  validates_presence_of :external_key, :chat, :body
  validate :must_connect_to_existing_chat_user
  after_create :raise_unread_count

  def must_connect_to_existing_chat_user
    unless chat.chat_users.exists?(external_key: external_key)
      errors.add(:external_key, "can't be from not existing chat user")
    end
  end

  def raise_unread_count
    chat_user = chat.chat_users.where.not(external_key: external_key).first
    chat_user.unread_count += chat_user.unread_count
  end
end
