class RemoveImageRatioFromEvent < ActiveRecord::Migration
  def change
    remove_column :events, :image_ratio, :string
  end
end
