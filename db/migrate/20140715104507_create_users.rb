class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid, :unique => true
      t.string :screen_name, :null => false
      t.string :profile_image_url, :default => ""
      t.string :name, :default => "Anon"
      t.date :login_last
      t.inet :last_ip
      t.string :access_token
      t.string :secret_token
      t.integer :gmod, :default => 0
      t.string :hd_channel, :null => false, :default => "0"
      t.integer :streamer, :default => 0
      t.string :twitch, :default => ""

      t.timestamps
      t.index :uid
    end
  end
end
