class AddValidatedToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :validated, :boolean
  end
end
