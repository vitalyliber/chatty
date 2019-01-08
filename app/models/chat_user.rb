class ChatUser < ApplicationRecord
  validates_presence_of :chat, :user
  validates_uniqueness_of :chat, scope: [:user]
  belongs_to :chat
  belongs_to :user
end
