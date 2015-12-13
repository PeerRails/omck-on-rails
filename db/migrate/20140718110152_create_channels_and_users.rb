class CreateChannelsAndUsers < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :channel, :unique => true
      t.boolean :live, :default => false
      t.integer :viewers, :default => 0, :null => false
      t.string :game, :default => "Boku no Pico", :null => false
      t.string :streamer, :default => "McDwarf"
      t.string :title, :default => "Boku wa Tomodachi ga Sekai"
      t.string :service, :default => "twitch"

      t.timestamps null: true
      t.index :channel
    end

    create_table :users do |t|
      t.string :uid, :unique => true
      t.string :screen_name, :default => "Null", :null => false
      t.string :profile_image_url
      t.string :name, :default => "Anon"
      t.integer :gmod, :default => 0
      t.integer :streamer, :default => 0
      t.date     :login_last
      t.inet     :last_ip
      t.string   :access_token
      t.string   :secret_token
      t.string :twitch


      t.timestamps null: true
    end
  end
end
