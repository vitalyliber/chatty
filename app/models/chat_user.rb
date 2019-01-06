class ChatUser < ApplicationRecord
  validates_presence_of :external_key
  belongs_to :chat
  belongs_to :user
end
