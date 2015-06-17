require 'rails_helper'

describe CreatePhoto do

  describe "Forced orientation portrait" do

    before(:each) do
      # Note that the name is important in that it directs to the
      # correct event directory
      @event = FactoryGirl.build(:event,
        name: "Event1",
        branded_image_width: 1200,
        branded_image_height: 1800,
        display_image_width: 400,
        display_image_height: 600,
        print_image_width: 1200,
        print_image_height: 1800
      )
    end

    it "should process a landscape with portait EXIF" do

      original_path = PNS.path_relative_to_project("#{PNS.event_capture_path(@event.name)}/landscape_right_top.JPG")

      @photo = @event.photosets.new.photos.build(original_path: original_path)

      CreatePhoto.call(@photo)

      original = PictureProcessor::Basel.new(PNS.full(@photo.original_path))
      expect(original.orientation).to eq :portrait

      expect(PNS.full(@photo.branded_path)).to have_dimensions(1200, 1800)
      expect(PNS.full(@photo.display_path)).to have_dimensions(400, 600)
      expect(PNS.full(@photo.printing_path)).to have_dimensions(1200, 1800)
    end

    it "should process a landscape with portait EXIF" do

      original_path = PNS.path_relative_to_project("#{PNS.event_capture_path(@event.name)}/landscape_top_left.JPG")

      @photo = @event.photosets.new.photos.build(original_path: original_path)

      CreatePhoto.call(@photo)

      original = PictureProcessor::Basel.new(PNS.full(@photo.original_path))
      expect(original.orientation).to eq :portrait

      expect(PNS.full(@photo.branded_path)).to have_dimensions(1200, 1800)
      expect(PNS.full(@photo.display_path)).to have_dimensions(400, 600)
      expect(PNS.full(@photo.printing_path)).to have_dimensions(1200, 1800)
    end
  end

  describe "Forced orientation landscape" do

    before(:each) do
      @event = FactoryGirl.build(:event,
        name: "Event1",
        branded_image_width: 1800,
        branded_image_height: 1200,
        display_image_width: 600,
        display_image_height: 400,
        print_image_width: 1800,
        print_image_height: 1200
      )
    end

    it "should process a landscape with portait EXIF" do

      original_path = PNS.path_relative_to_project("#{PNS.event_capture_path(@event.name)}/landscape_right_top.JPG")

      @photo = @event.photosets.new.photos.build(original_path: original_path)

      CreatePhoto.call(@photo)

      original = PictureProcessor::Basel.new(PNS.full(@photo.original_path))
      expect(original.orientation).to eq :landscape

      expect(PNS.full(@photo.branded_path)).to have_dimensions(1800, 1200)
      expect(PNS.full(@photo.display_path)).to have_dimensions(600, 400)
      expect(PNS.full(@photo.printing_path)).to have_dimensions(1800, 1200)
    end

    it "should process a landscape with landscape EXIF" do

      original_path = PNS.path_relative_to_project("#{PNS.event_capture_path(@event.name)}/landscape_top_left.JPG")

      @photo = @event.photosets.new.photos.build(original_path: original_path)

      CreatePhoto.call(@photo)

      original = PictureProcessor::Basel.new(PNS.full(@photo.original_path))
      expect(original.orientation).to eq :landscape

      expect(PNS.full(@photo.branded_path)).to have_dimensions(1800, 1200)
      expect(PNS.full(@photo.display_path)).to have_dimensions(600, 400)
      expect(PNS.full(@photo.printing_path)).to have_dimensions(1800, 1200)
    end
  end

  describe "Multiple orientations" do

    before(:each) do
      @event = FactoryGirl.build(:event,
        name: "Event1",
        multiple_orientations: true,
        branded_image_width: 1200,
        branded_image_height: 1800,
        display_image_width: 400,
        display_image_height: 600,
        print_image_width: 1200,
        print_image_height: 1800
      )
    end

    it "should process a landscape with portait EXIF" do

      original_path = PNS.path_relative_to_project("#{PNS.event_capture_path(@event.name)}/landscape_right_top.JPG")

      @photo = @event.photosets.new.photos.build(original_path: original_path)

      CreatePhoto.call(@photo)

      original = PictureProcessor::Basel.new(PNS.full(@photo.original_path))
      expect(original.orientation).to eq :portrait

      expect(PNS.full(@photo.branded_path)).to have_dimensions(1200, 1800)
      expect(PNS.full(@photo.display_path)).to have_dimensions(600, 600)
      expect(PNS.full(@photo.printing_path)).to have_dimensions(1200, 1800)
    end

    it "should process a landscape with landscape EXIF" do

      original_path = PNS.path_relative_to_project("#{PNS.event_capture_path(@event.name)}/landscape_top_left.JPG")

      @photo = @event.photosets.new.photos.build(original_path: original_path)

      CreatePhoto.call(@photo)

      original = PictureProcessor::Basel.new(PNS.full(@photo.original_path))
      expect(original.orientation).to eq :landscape

      expect(PNS.full(@photo.branded_path)).to have_dimensions(1800, 1200)
      expect(PNS.full(@photo.display_path)).to have_dimensions(600, 600)
      expect(PNS.full(@photo.printing_path)).to have_dimensions(1800, 1200)
    end

  end

end
