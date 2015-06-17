class AddCopyTwitterToEvents < ActiveRecord::Migration
  def change
    add_column :events, :copy_twitter, :string
  end
end
