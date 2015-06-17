class AddPhotosCountToPhotosets < ActiveRecord::Migration
  def change
    add_column :photosets, :photos_count, :integer, :null => false, :default => 0
  end
end
