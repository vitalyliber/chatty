class CreateChatUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_users do |t|
      t.string :external_key
      t.references :chat, foreign_key: true
      t.integer :unread_count

      t.timestamps
    end
  end
end
