class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.integer :uid, unique: true
      t.string :key, unique: true, null: false
      t.string :game, default: "Boku no Pico", null: false
      t.date :expires, null: false, default: DateTime.parse("2099-01-01")
      t.string :streamer, default: "McDwarf"

      t.timestamps null: true
    end
  end
end
