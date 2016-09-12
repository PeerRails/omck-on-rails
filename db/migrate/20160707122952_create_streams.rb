class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.integer :key_id, null: false
      t.integer :user_id, null: false
      t.integer :channel_id, null: false
      t.string :game
      t.string :movie
      t.string :streamer
      t.datetime :ended_at, null: true, default: nil

      t.timestamps null: false
    end
    add_index :streams, :key_id
    add_index :streams, :user_id
    add_index :streams, :channel_id
  end
end
