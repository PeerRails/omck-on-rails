class AddMovieToKeys < ActiveRecord::Migration
  def change
    add_column :keys, :movie, :string, default: "Boku Wa Tomodachi Ga Sekai"
  end
end
