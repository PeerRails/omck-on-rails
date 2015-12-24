class AddColumnCreatedByToKeys < ActiveRecord::Migration
  def change
    add_column :keys, :created_by, :integer
    add_index :keys, :created_by
    Key.where('user_id is not null').update_all("created_by = user_id")
    Key.where('user_id is null').update_all("created_by = 2")
  end
end
