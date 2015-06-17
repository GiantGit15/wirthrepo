describe "Application 'pbooth'" do
  extend WebStub::SpecHelpers

  before do
    @app ||= UIApplication.sharedApplication
    @delegate ||= @app.delegate
  end

  it "has two windows" do
    @app.windows.size.should == 2
  end

end
