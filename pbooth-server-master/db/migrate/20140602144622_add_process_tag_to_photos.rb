class AddProcessTagToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :process_tag, :string
  end
end
