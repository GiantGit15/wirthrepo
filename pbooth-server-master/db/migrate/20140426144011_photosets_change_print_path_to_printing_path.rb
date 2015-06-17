class PhotosetsChangePrintPathToPrintingPath < ActiveRecord::Migration
  def change
    rename_column :photosets, :print_path, :printing_path
  end
end
