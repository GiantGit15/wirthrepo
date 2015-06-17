class AddUrlToPhotosets < ActiveRecord::Migration
  def change

    add_column :photosets, :url, :string
  end
end
