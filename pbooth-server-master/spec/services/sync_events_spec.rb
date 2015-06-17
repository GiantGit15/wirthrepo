require 'rails_helper'

describe SyncEvents do

  # There should be two events in the FS. "Event1"  and "Event2"

  specify "a clean db" do
    expect(Event.count).to eq 0
  end

  specify "events in the database should sync with events in the file system" do

    # create an event that is not in the FS
    event_not_in_fs = FactoryGirl.create(:event)

    # create an event that is in the FS
    event_in_fs = FactoryGirl.create(:event, name: "Event1")

    SyncEvents.call

    expect{ Event.find(event_not_in_fs.id) }.to raise_error(ActiveRecord::RecordNotFound)
    expect{ Event.find(event_in_fs.id) }.not_to raise_error
    expect(Event.where(name: "Event2").first).not_to be nil
  end

end
