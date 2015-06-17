class AddSettingsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :image_ratio, :string
    add_column :events, :photos_in_set, :integer
    add_column :events, :branded_image_width, :integer
    add_column :events, :branded_image_height, :integer
    add_column :events, :display_image_width, :integer
    add_column :events, :display_image_height, :integer
    add_column :events, :copy_email_subject, :string
    add_column :events, :copy_email_body, :text
    add_column :events, :copy_social, :text
  end
end
