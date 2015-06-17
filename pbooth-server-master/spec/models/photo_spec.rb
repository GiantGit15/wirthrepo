require "rails_helper"

RSpec.describe Photo, :type => :model do

  describe "factories" do
    it "should create a photo" do
      photo = create(:photo)

      p PNS.full(photo.original_path)

      expect(File.exist?(PNS.full(photo.original_path))).to be true
      expect(File.exist?(PNS.full(photo.branded_path))).to be true
      expect(File.exist?(PNS.full(photo.display_path))).to be true
      expect(File.exist?(PNS.full(photo.printing_path))).to be true
    end
  end
end
