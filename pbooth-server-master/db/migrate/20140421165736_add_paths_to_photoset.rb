class AddPathsToPhotoset < ActiveRecord::Migration
  def change
    add_column :photosets, :display_path, :string
    add_column :photosets, :print_path, :string
  end
end
