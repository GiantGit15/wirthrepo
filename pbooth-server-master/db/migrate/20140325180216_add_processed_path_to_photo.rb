class AddProcessedPathToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :processed_path, :string
  end
end
