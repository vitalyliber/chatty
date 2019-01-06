class User < ApplicationRecord
  validates_presence_of :external_key, :name, :avatar_url
  has_many :chat_users

  def appear
    self.update(online: true)
  end

  def disappear
    self.update(online: false)
  end
end
