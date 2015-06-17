require 'rails_helper'

describe PictureProcessor::Basel do

  let(:portrait_path) { "#{Rails.root}/Test Project/sample_photos/Original/portrait.jpg" }
  let(:landscape_path) { "#{Rails.root}/Test Project/sample_photos/Original/landscape.jpg" }

  before(:each) do
    @test_input_path = "#{Rails.root}/Test Project/sample_photos/Original/portrait.jpg"
    @test_output_path = "#{Rails.root}/Test Project/Test Images/test.jpg"

    File.delete(@test_output_path) if File.exist?(@test_output_path)
  end

  it "should initialize with a path" do
    initial_image = PictureProcessor::Basel.new(@test_input_path)

    expect(initial_image.path).to eq @test_input_path
  end

  it "should have some basic properties" do
    initial_image = PictureProcessor::Basel.new(@test_input_path)

    expect(initial_image.image.class).to be Magick::Image
    expect(initial_image.width).not_to be nil
    expect(initial_image.height).not_to be nil
    expect(initial_image.orientation).not_to be nil

  end

  describe "#orientation" do
    xit "should provide the correct orientation for various EXIF types" do
    end

    it "should provide the correct orientation" do
      initial_image = PictureProcessor::Basel.new(portrait_path)
      expect(initial_image.orientation).to eq :portrait

      initial_image = PictureProcessor::Basel.new(landscape_path)
      expect(initial_image.orientation).to eq :landscape
    end

  end

  describe "#write" do

    it "should raise an argument error when no path is specified" do
      expect { PictureProcessor::Basel.new(@test_input_path).write(nil) }.to raise_error(ArgumentError)
    end

    it "should write the image to the specified path" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      initial_image.write(@test_output_path)
      expect(File.exist?(@test_output_path)).to be true
    end

    it "should update the path" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      initial_image.write(@test_output_path)
      expect(initial_image.path).to eq @test_output_path
    end

    it "should create the directory if it doesnt exist" do
      FileUtils.remove_dir(File.dirname(@test_output_path))
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      initial_image.write(@test_output_path)
      expect(File.exist?(@test_output_path)).to be true
    end

    it "should be chainable" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      test_result = initial_image.write(@test_output_path)
      expect(test_result).to be initial_image
    end

    it "should be and_thenable" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      new_image = initial_image.and_then do |x|
        x.write(@test_output_path)
      end
      expect(new_image.path).to eq @test_output_path
      expect(File.exist?(@test_output_path)).to be true
    end
  end

  describe "#resize" do
    it "should resize an image" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      initial_image.resize(100, 200)
      expect(initial_image.width).to eq 100
      expect(initial_image.height).to eq 200
    end

    it "should be chainable" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      test_result = initial_image.resize(200,100)
      expect(test_result).to be initial_image
    end

    it "should produce an Image" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      initial_image.resize(400,400)
      expect(initial_image.image.class).to be Magick::Image
    end

  end

  describe "#resize_to_magnitude" do
    it "should resize a portrait image" do
      initial_image = PictureProcessor::Basel.new(portrait_path)
      initial_image.resize_to_magnitude(100, 200)
      expect(initial_image.width).to eq 100
      expect(initial_image.height).to eq 200
    end

    it "should resize a landscape image" do
      initial_image = PictureProcessor::Basel.new(landscape_path)
      initial_image.resize_to_magnitude(100, 200)
      expect(initial_image.width).to eq 200
      expect(initial_image.height).to eq 100
    end

    it "should matter what order you specify arguments" do
      initial_image = PictureProcessor::Basel.new(portrait_path)
      initial_image.resize_to_magnitude(100, 200)
      expect(initial_image.width).to eq 100
      expect(initial_image.height).to eq 200

      initial_image = PictureProcessor::Basel.new(portrait_path)
      initial_image.resize_to_magnitude(200, 100)
      expect(initial_image.width).to eq 100
      expect(initial_image.height).to eq 200
    end

    it "should be chainable" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      test_result = initial_image.resize_to_magnitude(200,100)
      expect(test_result).to be initial_image
    end

    it "should be and_thenable" do
      initial_image = PictureProcessor::Basel.new(portrait_path)
      new_image = initial_image.and_then do |x|
        x.resize_to_magnitude(200, 100)
      end
      expect(new_image.width).to eq 100
      expect(new_image.height).to eq 200
    end
    
    it "should produce an Image" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      initial_image.resize_to_magnitude(400,400)
      expect(initial_image.image.class).to be Magick::Image
    end
  end

  describe "#resize_to_fill" do
    it "should resize to a square" do
      initial_image = PictureProcessor::Basel.new(portrait_path)
      initial_image.resize_to_magnitude(100, 100)
      expect(initial_image.width).to eq 100
      expect(initial_image.height).to eq 100
    end

    it "should be chainable" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      test_result = initial_image.resize_to_fill(100,100)
      expect(test_result).to be initial_image
    end

    it "should produce an ImageList" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      initial_image.resize_to_fill(400,400)
      expect(initial_image.image.class).to be Magick::Image
    end

  end

  describe "#orient" do

    def it_should_orient_to(input_path, forced_orientation, expected_orientation)
      initial_image = PictureProcessor::Basel.new(input_path)
      initial_image.orient(forced_orientation)
      initial_image.write(@test_output_path)

      image_should_have_orientation(@test_output_path, expected_orientation)
    end

    def image_should_have_orientation(path, orientation)
      image = Magick::ImageList.new(path)
      case orientation
      when :portrait
        expect(image.columns.to_f / image.rows).to be <= 1
      when :landscape
        expect(image.columns.to_f / image.rows).to be > 1
      else
        expect([:portrait, :landscape]).to include orientation
      end
    end

    # Much of this test will focus on EXIF information. Its important to
    # get this right so we can call .orient have have confidence that it
    # is always what we expect

    it "should not alter the input image" do
       initial_image = PictureProcessor::Basel.new(landscape_path)
       initial_image.orient(:portrait)

       image_should_have_orientation(landscape_path, :landscape)
     end

    it "should be chainable" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      test_result = initial_image.orient
      expect(test_result).to be initial_image
    end

    it "should produce an Image" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      initial_image.orient(:portrait)
      expect(initial_image.image.class).to be Magick::Image
    end


   describe "a landscape image with portrait EXIF info" do
     let(:input_path) { "#{Rails.root}/Test Project/sample_photos/landscape_right_top.jpg" }

     it "shoud orient with :landscape, :portrait, :none and nil" do
       it_should_orient_to(input_path, :none, :portrait)
       it_should_orient_to(input_path, nil, :portrait)
       it_should_orient_to(input_path, :portrait, :portrait)
       it_should_orient_to(input_path, :landscape, :landscape)
     end
   end

   describe "a landscape image with no EXIF info" do
     let(:input_path) { "#{Rails.root}/Test Project/sample_photos/landscape_none.jpg" }

     it "shoud orient with :landscape, :portrait, :none and nil" do
       it_should_orient_to(input_path, :none, :landscape)
       it_should_orient_to(input_path, nil, :landscape)
       it_should_orient_to(input_path, :portrait, :portrait)
       it_should_orient_to(input_path, :landscape, :landscape)
     end
   end

   describe "a landscape image with landscape EXIF info" do
     let(:input_path) { "#{Rails.root}/Test Project/sample_photos/landscape_top_left.jpg" }

     it "shoud orient with :landscape, :portrait, :none and nil" do
       it_should_orient_to(input_path, :none, :landscape)
       it_should_orient_to(input_path, nil, :landscape)
       it_should_orient_to(input_path, :portrait, :portrait)
       it_should_orient_to(input_path, :landscape, :landscape)
     end
   end

  end

  describe "#overlay" do
    let(:portrait_logo_path) { "#{Rails.root}/Test Project/sample_photos/portrait_logo.png" }
    let(:nowhere_path) { "#{Rails.root}/Test Project/sample_photos/doesnt_exist.png" }

    xit "should change the image file" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      initial_image.overlay(portrait_logo_path)
    end

    it "should handle a missing file or a nil argument and do nothing" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)

      initial_image.overlay(nil)

      initial_image.overlay(nowhere_path)
    end

    it "should be chainable" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      test_result = initial_image.overlay(portrait_logo_path)
      expect(test_result).to be initial_image
    end

   it "should produce an Image" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      initial_image.overlay(portrait_logo_path)
      expect(initial_image.image.class).to be Magick::Image
    end

    
  end


  describe "#and_then" do
    it "should create a new instance" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      new_image = initial_image.and_then {|x|}

      expect(new_image.class).to be PictureProcessor::Basel
      expect(new_image.object_id).not_to eq initial_image.object_id
    end

    it "it should pass the new instance into the block" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      test_id = -1
      new_image = initial_image.and_then do |x|
        test_id = x.object_id
      end
      expect(new_image.object_id).to eq test_id
    end
  end

  describe "#display" do
    let(:portrait_logo_path) { "#{Rails.root}/Test Project/sample_photos/portrait_logo.png" }
    it "should display" do
      initial_image = PictureProcessor::Basel.new(@test_input_path)
      new_image = initial_image.and_then do |x|
        x.overlay(portrait_logo_path)
      end
      #initial_image.display
      #new_image.display
    end
  end

end
