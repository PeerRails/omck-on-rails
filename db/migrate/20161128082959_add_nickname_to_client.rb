class AddNicknameToClient < ActiveRecord::Migration[5.0]
  def change
	  add_column :clients, :nickname, :string, null: false
	  add_column :clients, :nicknumber, :integer 
  end
end
