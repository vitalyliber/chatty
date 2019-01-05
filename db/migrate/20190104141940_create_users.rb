class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :external_key
      t.string :name
      t.boolean :online, default: false

      t.timestamps
    end
  end
end
