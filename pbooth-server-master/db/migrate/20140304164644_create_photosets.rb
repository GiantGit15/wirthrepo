class CreatePhotosets < ActiveRecord::Migration
  def change
    create_table :photosets do |t|
      t.integer :event_id

      t.timestamps
    end
  end
end
