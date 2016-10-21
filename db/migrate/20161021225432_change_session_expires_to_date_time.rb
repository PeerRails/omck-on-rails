class ChangeSessionExpiresToDateTime < ActiveRecord::Migration
  def change
    change_column :sessions, :expires, :datetime
  end
end
