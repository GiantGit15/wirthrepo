class AddSmugmugAlbumToEvents < ActiveRecord::Migration
  def change
    add_column :events, :smugmug_album, :string
  end
end
