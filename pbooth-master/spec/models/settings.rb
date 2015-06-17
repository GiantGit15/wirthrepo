# The Settings model is a singleton. It is uses in conjunction with
# SettingsController to store and access app wide settings.

describe "Settings" do

  it "should have a default server_url method" do
    Settings.server_url.should == "http://localhost:3000"
  end
end
