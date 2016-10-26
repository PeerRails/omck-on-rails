class AddStreamIdToVideo < ActiveRecord::Migration[5.0]
  def change
      add_column :videos, :stream_id, :integer
  end
end
