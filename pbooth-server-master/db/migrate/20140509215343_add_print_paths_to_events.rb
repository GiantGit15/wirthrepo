class AddPrintPathsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :print_image_width, :integer
    add_column :events, :print_image_height, :integer
  end
end
