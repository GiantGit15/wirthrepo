class AddOptionsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :option_smugmug, :boolean
    add_column :events, :option_facebook, :boolean
    add_column :events, :option_twitter, :boolean
    add_column :events, :option_email, :boolean
    add_column :events, :option_print, :boolean
  end
end
