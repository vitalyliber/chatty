class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :external_key
      t.index :external_key
      t.string :name
      t.string :avatar_url
      t.boolean :online, default: false
      t.datetime :online_at, default: -> { 'NOW()' }

      t.timestamps
    end
  end
end
