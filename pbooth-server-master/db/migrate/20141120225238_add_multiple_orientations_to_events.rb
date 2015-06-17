class AddMultipleOrientationsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :multiple_orientations, :boolean, default: false
  end
end
