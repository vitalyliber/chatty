class CreateChatUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_users do |t|
      t.references :chat, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :unread_count, default: 0

      t.timestamps
    end
  end
end
