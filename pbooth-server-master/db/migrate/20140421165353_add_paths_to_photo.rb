class AddPathsToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :original_path, :string
    add_column :photos, :display_path, :string
    add_column :photos, :print_path, :string

    remove_column :photos, :path, :string
    remove_column :photos, :processed_path, :string
  end
end
