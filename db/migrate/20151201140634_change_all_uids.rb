class ChangeAllUids < ActiveRecord::Migration
  def change
    rename_column :videos, :uid,  :token
  end
end
