class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.inet :ip
      t.integer :user_id

      t.timestamps null: true
    end
  end
end
