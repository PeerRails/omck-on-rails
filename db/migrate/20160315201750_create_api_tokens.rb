class CreateApiTokens < ActiveRecord::Migration
  def change
    create_table :api_tokens do |t|
      t.string :secret, :unique => true
      t.integer :user_id
      t.timestamp :expires_at

      t.timestamps null: false
    end
    add_index :api_tokens, :secret
    add_index :api_tokens, :user_id
  end
end
