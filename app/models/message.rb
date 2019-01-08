class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user
  validates_presence_of :chat, :body
  validate :must_connect_to_existing_chat_user
  after_create :raise_unread_count

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
end
