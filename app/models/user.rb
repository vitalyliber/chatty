class User < ApplicationRecord
  validates_presence_of :external_key, :name, :avatar_url
  has_many :chat_users
  has_many :messages

  def appear
    self.update(online: true, online_at: Time.now)
  end

  def disappear
    self.update(online: false, online_at: Time.now)
  end
end
