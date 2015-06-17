class AddBrandedPathToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :branded_path, :string
  end
end
