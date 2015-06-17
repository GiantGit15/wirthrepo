# THe event class is a singleton, we are only ever concerned with the
# current event.

describe "Event" do

  it "should ::fetch data from the server and persist it" do
    Event.fetch
    1.should == 1
  end

  it "should ::get the data from the persistence layer" do
    Event.get.should != nil
  end
end
