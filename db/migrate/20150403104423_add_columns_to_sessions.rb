class AddColumnsToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :expires, :date
    add_column :sessions, :session_id, :string

    change_table :sessions do |t|
      t.index :session_id
    end
  end
end
