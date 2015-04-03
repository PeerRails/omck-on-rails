class AddGuestSession < ActiveRecord::Migration
  def change
    add_column :sessions, :guest, :boolean, default: false
  end
end
