class MakeChannelsOfficial < ActiveRecord::Migration
  def change
    pairs = [
      {:channel => "mc_mc_mc_omck", :service => "livestream"},
      {:channel => "hdgames", :service => "hd"},
      {:channel => "hdkinco", :service => "hd"},
      {:channel => "omcktv", :service => "twitch"}
    ]
    pairs.each do |pair|
      chan = Channel.where(pair).last
      chan.update_attributes(official: true)
    end
  end
end
