class AddDeviseFieldForUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.datetime "remember_created_at"
      t.string   "remember_token"
      t.integer  "sign_in_count",       :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
    end
  end
end
