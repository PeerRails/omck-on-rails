class AddGuestToKeys < ActiveRecord::Migration
  def change
    add_column :keys, :guest, :boolean, default: false
  end
end
