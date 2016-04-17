class ChangeNumToBoolRoles < ActiveRecord::Migration
  def change
    change_column :users, :gmod, :integer, :default => 0, :null => false, :precision => 1
    change_column :users, :streamer, :integer, :default => 0, :null => false, :precision => 1
  end
end
