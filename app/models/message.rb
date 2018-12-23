class Message < ApplicationRecord
  belongs_to :chat
  validates_presence_of :external_key, :chat, :body
  validate :must_connect_to_existing_chat_user

  def must_connect_to_existing_chat_user
    unless chat.chat_users.exists?(external_key: external_key)
      errors.add(:external_key, "can't be from not existing chat user")
    end
  end
end
