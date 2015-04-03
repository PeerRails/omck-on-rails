class AddColumnOficialChannels < ActiveRecord::Migration
  def change
  	add_column :channels, :official, :boolean, default: false
  end
end

