class CreateEmailConfirmationTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :email_confirmation_tokens do |t|
      t.integer :client_id
      t.string :secret
      t.boolean :confirmed, default: false

      t.timestamps
    end
    add_index :email_confirmation_tokens, :client_id
  end
end
