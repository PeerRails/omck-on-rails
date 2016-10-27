class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :provider
      t.integer :provider_user_id
      t.string :username
      t.string :fullname
      t.string :link
      t.integer :client_id
      t.string :profile_pic

      t.timestamps
    end
    add_index :accounts, :provider
    add_index :accounts, :provider_user_id
    add_index :accounts, :client_id
  end
end
