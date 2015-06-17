class PhotosChangePrintPathToPrintingPath < ActiveRecord::Migration
  def change
    rename_column :photos, :print_path, :printing_path
  end
end
