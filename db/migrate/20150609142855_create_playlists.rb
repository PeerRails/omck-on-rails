class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.integer :video_id
      t.integer :status
      t.string :path
      t.string :thumb

      t.timestamps null: false
    end
    add_index :playlists, :video_id
  end
end
