require 'rails_helper'

describe CreateGif do

  describe "Forced orientation portrait" do

    before(:each) do
      @event = FactoryGirl.create(:gif_event,
        name: "Event2",
        branded_image_width: 600,
        branded_image_height: 900,
        display_image_width: 400,
        display_image_height: 600,
        print_image_width: 1200,
        print_image_height: 1800
      )
    end

    it "should process a landscape with portait EXIF" do
      @photoset = @event.photosets.create

      (1..6).map{ |n| "lrt#{n}.JPG" }.each do |filename|
        original_path = PNS.path_relative_to_project("#{PNS.event_capture_path(@event.name)}/#{filename}")
        @photoset.photos.create(original_path: original_path)
      end

      expect(@photoset).not_to be nil

      CreateGif.call(@photoset, false)

      expect(PNS.full(@photoset.branded_path)).to have_dimensions(600, 900)
      expect(PNS.full(@photoset.display_path)).to have_dimensions(400, 600)
      expect(PNS.full(@photoset.printing_path)).to have_dimensions(1200, 1800)
    end

    it "should process a landscape with landscape EXIF" do
      @photoset = @event.photosets.create

      (1..6).map{ |n| "llt#{n}.JPG" }.each do |filename|
        original_path = PNS.path_relative_to_project("#{PNS.event_capture_path(@event.name)}/#{filename}")
        @photoset.photos.create(original_path: original_path)
      end

      expect(@photoset).not_to be nil

      CreateGif.call(@photoset, false)

      expect(PNS.full(@photoset.branded_path)).to have_dimensions(600, 900)
      expect(PNS.full(@photoset.display_path)).to have_dimensions(400, 600)
      expect(PNS.full(@photoset.printing_path)).to have_dimensions(1200, 1800)
    end

  end

  describe "Forced orientation landscape" do

    before(:each) do

      @event = FactoryGirl.create(:gif_event,
        name: "Event2",
        branded_image_width: 900,
        branded_image_height: 600,
        display_image_width: 600,
        display_image_height: 400,
        print_image_width: 1800,
        print_image_height: 1200
      )
    end

    it "should process a landscape with portait EXIF" do
      @photoset = @event.photosets.create

      (1..6).map{ |n| "lrt#{n}.JPG" }.each do |filename|
        original_path = PNS.path_relative_to_project("#{PNS.event_capture_path(@event.name)}/#{filename}")
        @photoset.photos.create(original_path: original_path)
      end
 
      expect(@photoset).not_to be nil

      CreateGif.call(@photoset, false)

      expect(PNS.full(@photoset.branded_path)).to have_dimensions(900, 600)
      expect(PNS.full(@photoset.display_path)).to have_dimensions(600, 400)
      expect(PNS.full(@photoset.printing_path)).to have_dimensions(1800, 1200)
    end

    it "should process a landscape with landscape EXIF" do
       @photoset = @event.photosets.create

      (1..6).map{ |n| "llt#{n}.JPG" }.each do |filename|
        original_path = PNS.path_relative_to_project("#{PNS.event_capture_path(@event.name)}/#{filename}")
        @photoset.photos.create(original_path: original_path)
      end

      expect(@photoset).not_to be nil

      CreateGif.call(@photoset, false)

      expect(PNS.full(@photoset.branded_path)).to have_dimensions(900, 600)
      expect(PNS.full(@photoset.display_path)).to have_dimensions(600, 400)
      expect(PNS.full(@photoset.printing_path)).to have_dimensions(1800, 1200)
    end

  end

end
