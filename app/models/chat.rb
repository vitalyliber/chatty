class Chat < ApplicationRecord
  has_many :chat_users
  has_many :messages
end
