class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name, default: "Dwarf"
      t.string :email
      t.string :password
      t.boolean :admin, default: false
      t.boolean :streamer, default: false
      t.boolean :bot, default: false
      t.datetime :verified, default: nil
      t.datetime :remember_at
      t.datetime :last_login

      t.timestamps
    end
    add_index :clients, :email
    add_index :clients, :password
    add_index :clients, :admin
    add_index :clients, :streamer
    add_index :clients, :bot
  end
end
