class CreateEmailChangeTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :email_change_tokens do |t|
      t.integer :client_id
      t.string :secret
      t.boolean :confirmed, default: false
      t.string :old_email
      t.string :new_email

      t.timestamps
    end
    add_index :email_change_tokens, :client_id
  end
end
