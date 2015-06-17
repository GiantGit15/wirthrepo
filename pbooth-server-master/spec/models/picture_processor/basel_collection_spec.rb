require 'rails_helper'

describe PictureProcessor::BaselCollection do

  let(:lrt_paths) do
    [ "#{Rails.root}/Test Project/sample_photos/Collections/lrt1.JPG",
      "#{Rails.root}/Test Project/sample_photos/Collections/lrt2.JPG" ]
  end

  before(:each) do
    @test_output_dir = "#{Rails.root}/Test Project/Test Images"
    Pathname.new(@test_output_dir).children.each { |p| p.rmtree }
  end

  it "should delegate [] and each to @collection and be enumerable" do
    initial = PictureProcessor::BaselCollection.new(lrt_paths)

    expect(initial.respond_to?(:[])).to be true
    expect(initial.respond_to?(:each)).to be true
    expect(initial.respond_to?(:map)).to be true
  end

  it "should initialize with a path" do
    initial = PictureProcessor::BaselCollection.new(lrt_paths)

    expect(initial[0].class).to be PictureProcessor::Basel
    expect(initial[1].class).to be PictureProcessor::Basel
  end

  describe "#orient" do

    it "should respond_to orient" do
      initial = PictureProcessor::BaselCollection.new(lrt_paths)
      expect(initial.respond_to?(:orient)).to be true
    end

    it "should orient with no arguments" do
      initial = PictureProcessor::BaselCollection.new(lrt_paths)

      initial.orient

      initial.each do |x|
        expect(x.orientation).to eq :portrait
      end
    end

    it "should orient to :portrait" do
      initial = PictureProcessor::BaselCollection.new(lrt_paths)

      initial.orient(:portrait)

      initial.each do |x|
        expect(x.orientation).to eq :portrait
      end
    end

    it "should orient to :landscape" do
      initial = PictureProcessor::BaselCollection.new(lrt_paths)

      initial.orient(:landscape)

      initial.each do |x|
        expect(x.orientation).to eq :landscape
      end
    end

    it "should be chainable" do
      initial = PictureProcessor::BaselCollection.new(lrt_paths)
      test_result = initial.orient
      expect(test_result).to be initial
    end

    it "should be and_thenable" do
      initial = PictureProcessor::BaselCollection.new(lrt_paths)
      new_collection = initial.and_then do |x|
        x.orient
      end

      new_collection.each do |x|
        expect(x.orientation).to eq :portrait
      end
    end

  end

  describe "#write" do

    let(:test_gif_path) { "#{Rails.root}/Test Project/Test Images/Gifs/imagif.gif" }

    #before(:each) do
    #  File.delete(test_gif_path) if File.exist?(test_gif_path)
    #end

    it "should write a gif to the specified path" do

      initial = PictureProcessor::BaselCollection.new(lrt_paths)
      initial.write(test_gif_path)

      expect(File.exist?(test_gif_path)).to be true
    end

    it "should be and_thenable" do
      initial = PictureProcessor::BaselCollection.new(lrt_paths)
      new_collection = initial.and_then do |x|
        x.write(test_gif_path)
      end

      expect(File.exist?(test_gif_path)).to be true
    end

  end

  describe "resize" do
    it "should resize the collection" do
      initial = PictureProcessor::BaselCollection.new(lrt_paths)
      initial.resize(400, 600)
      initial.each do |x|
        expect(x.width).to eq 400
        expect(x.height).to eq 600
      end
    end
  end

  describe "overlay" do
    let(:portrait_logo_path) { "#{Rails.root}/Test Project/sample_photos/portrait_logo.png" }
    let(:test_gif_path) { "#{Rails.root}/Test Project/Test Images/imagif.gif" }

    it "should overlay each int he collection" do
      initial = PictureProcessor::BaselCollection.new(lrt_paths)

      initial.overlay(portrait_logo_path)

      #initial.write(test_gif_path)
    end

  end

  describe "combo" do
    let(:portrait_logo_path) { "#{Rails.root}/Test Project/sample_photos/portrait_logo.png" }
    let(:test_gif_path) { "#{Rails.root}/Test Project/Test Images/imagif.gif" }
    let(:test_display_path) { "#{Rails.root}/Test Project/Test Images/display.jpg" }

    xit "should combo two" do
      oriented = PictureProcessor::Basel.new(lrt_paths.first).and_then do |x|
        x.orient(:portrait)
      end

      branded = oriented.and_then do |x|
        x.resize(600, 900)
        x.overlay(portrait_logo_path)
      end

      display = oriented.and_then do |x|
        x.resize(400, 400)
        x.write(test_display_path)
      end

      display.display


    end
  end
end

