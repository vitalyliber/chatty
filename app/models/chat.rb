class Chat < ApplicationRecord
  has_many :chat_users, dependent: :destroy
  has_many :messages, dependent: :destroy
  validate :external_keys_must_uniq

  def external_keys_must_uniq
    unless new_record?
      keys = chat_users.map {|el| el.id}
      if keys[0] == keys[1]
        errors.add(:id, "can't be the same for both users")
      end
    end
  end

  def opponent(current_user_id)
    chat_users.select {|el| el.user.id != current_user_id}[0]
  end
end
