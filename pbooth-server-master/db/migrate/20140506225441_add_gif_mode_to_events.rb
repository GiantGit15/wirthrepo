class AddGifModeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :gif_mode, :boolean
  end
end
