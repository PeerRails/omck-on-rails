class ChangeExpireToDateTime < ActiveRecord::Migration
  def change
        change_column :keys, :expires, :datetime
  end
end
