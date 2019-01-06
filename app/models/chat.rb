class Chat < ApplicationRecord
  has_many :chat_users, dependent: :destroy
  has_many :messages, dependent: :destroy
  validate :external_keys_must_uniq

  def external_keys_must_uniq
    keys = chat_users.map {|el| el.external_key}
    if keys[0] == keys[1]
      errors.add(:external_key, "can't be the same for both users")
    end
  end
end
