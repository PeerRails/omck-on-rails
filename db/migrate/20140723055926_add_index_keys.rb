class AddIndexKeys < ActiveRecord::Migration
  def change
    change_table :keys do |t|4
      t.index :key
    end
  end
end
