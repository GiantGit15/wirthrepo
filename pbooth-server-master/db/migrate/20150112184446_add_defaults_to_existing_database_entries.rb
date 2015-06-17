class AddDefaultsToExistingDatabaseEntries < ActiveRecord::Migration
  def change
    Event.find_each do |event|
      event.set_defaults
      event.save
    end
  end
end
