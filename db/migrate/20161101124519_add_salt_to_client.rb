class AddSaltToClient < ActiveRecord::Migration[5.0]
  def change
      add_column :clients, :salt, :string
  end
end
