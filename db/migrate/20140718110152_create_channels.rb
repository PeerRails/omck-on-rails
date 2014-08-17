class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :channel, :unique => true
      t.boolean :live, :default => false
      t.integer :viewers, :default => 0, :null => false
      t.string :game, :default => "Boku no Pico", :null => false
      t.string :streamer, :default => "McDwarf"
      t.string :title, :default => "Boku wa Tomodachi ga Sekai"
      t.string :service, :default => "twitch"

      t.timestamps
      t.index :channel
    end
  end
end
