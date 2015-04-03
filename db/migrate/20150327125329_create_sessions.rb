class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.inet :ip
      t.string :user_id

      t.timestamps
    end
  end
end
