class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :game, default: "Boku no Pico", null: false
      t.integer :user_id
      t.integer :key_id
      t.string :youtube_id
      t.text :description, default: "Boku no Pico"
      t.string :uid, null: false
      t.string :path
      t.boolean :deleted, default: false

      t.timestamps null: false
    end
  end
end
