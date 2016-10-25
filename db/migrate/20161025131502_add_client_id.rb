class AddClientId < ActiveRecord::Migration[5.0]
  def change
    add_column :keys, :client_id, :integer
    add_column :tweets, :client_id, :integer
    add_column :sessions, :client_id, :integer
    add_column :videos, :client_id, :integer
    add_column :api_tokens, :client_id, :integer
    add_column :streams, :client_id, :integer

    [Key, Tweet, Session, Video, ApiToken, Stream].each do |model|
        model.all.each do |record|
            record.client_id = record.user_id
            record.save
        end
    end

    add_index :keys, :client_id
    add_index :tweets, :client_id
    add_index :sessions, :client_id
    add_index :videos, :client_id
    add_index :api_tokens, :client_id
    add_index :streams, :client_id
  end
end
