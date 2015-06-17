class AddValidatedToPhotosets < ActiveRecord::Migration
  def change
    add_column :photosets, :validated, :boolean
  end
end
