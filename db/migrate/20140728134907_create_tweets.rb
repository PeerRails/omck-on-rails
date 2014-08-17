class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :uid, default: 1, null: false
      t.string :author, default: "Wombo Combo"
      t.text :comment, null: false
      t.integer :type, default: 2, null: false

      t.timestamps
      t.index :uid
    end
  end
end
