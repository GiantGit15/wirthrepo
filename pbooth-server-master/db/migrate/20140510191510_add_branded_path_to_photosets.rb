class AddBrandedPathToPhotosets < ActiveRecord::Migration
  def change
    add_column :photosets, :branded_path, :string
  end
end
