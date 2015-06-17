require "rails_helper"

RSpec.describe Photoset, :type => :model do

  describe "factories" do
    it "should create a gif" do
      gif = create(:gif)
      expect(gif.photos.count).to be 6

      gif.photos.each do |photo|
        expect(File.exist?(PNS.full(photo.original_path))).to be true
      end

      expect(File.exist?(PNS.full(gif.branded_path))).to be true
      expect(File.exist?(PNS.full(gif.display_path))).to be true
      expect(File.exist?(PNS.full(gif.printing_path))).to be true
    end
  end
end

