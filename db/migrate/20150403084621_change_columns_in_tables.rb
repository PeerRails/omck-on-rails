class ChangeColumnsInTables < ActiveRecord::Migration
  def change
    rename_column :keys, :uid, :user_id
    rename_column :tweets, :uid, :user_id
    rename_column :users, :uid, :twitter_id
    remove_column :tweets, :author
    remove_column :tweets, :tipe
    remove_column :users, :twitch

    change_table :keys do |t|4
      t.index :user_id
    end

    add_index "users", ["twitter_id"], name: "index_users_on_twitter_id", using: :btree
  end
end
