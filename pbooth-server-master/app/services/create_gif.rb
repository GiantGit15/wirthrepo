# CreateGif contains the logic of creating a gif. It will combine all photos in the set into a gif
# Wants
#   A Photoset full of photos
#
class CreateGif

  def self.call(*args)
    new(*args).call
  end

  def initialize(photoset, will_upload=false)
    @photoset = photoset
    @event = @photoset.event
    @will_upload = will_upload
  end

  def call
    start_time = Time.now

    paths = @photoset.photos.map { |photo| PNS.full(photo.original_path) }

    oriented = PictureProcessor::BaselCollection.new(paths).and_then do |x|
      x.orient(@event.orientation)
    end

    oriented.and_then do |x|
      make_branded_version(x)
    end

    oriented.first.and_then do |x|
      make_display_version(x)
    end

    oriented.and_then do |x|
      make_printing_version(x)
    end

    @photoset.validate
    @photoset.save

    # Upload
    Resque.enqueue(UploadPhotoGetUrlJob, @photoset.id) if @will_upload

    puts "CreateGif #{@photoset.id} in #{ Time.now.to_f - start_time.to_f } s"
  end

  def make_branded_version(x)
    branded_size = [@event.branded_image_width, @event.branded_image_height]
    x.resize(*branded_size)
    logo_path = PNS.fetch_event_logo_path(@event.name, @event.orientation)
    x.overlay(logo_path)
    gif_branded_path = "#{PNS.event_path(@event.name)}/Processed/Gifs/Branded/#{@photoset.id}.gif"
    x.write(gif_branded_path)
    @photoset.branded_path = PNS.path_relative_to_project(gif_branded_path)
  end

  def make_display_version(x)
    gif_display_path = "#{PNS.event_path(@event.name)}/Processed/Gifs/Display/#{@photoset.id}.jpg"
    display_size = [@event.display_image_width, @event.display_image_height]
    x.resize(*display_size)
    logo_path = PNS.fetch_event_logo_path(@event.name, @event.orientation)
    x.overlay(logo_path)
    x.write(gif_display_path)
    @photoset.display_path = PNS.path_relative_to_project(x.path)
  end

  def make_printing_version(x)
      gif_printing_path = "#{PNS.event_path(@event.name)}/Processed/Gifs/Print/#{@photoset.id}.jpg"
      print_logo_path = PNS.event_print_logo_path(@event.name)

      margin_top = ENV['GIF_PRINT_MARGIN_TOP'].to_i || 0
      margin_right = ENV['GIF_PRINT_MARGIN_RIGHT'].to_i || 0
      margin_bottom = ENV['GIF_PRINT_MARGIN_BOTTOM'].to_i || 0
      margin_left = ENV['GIF_PRINT_MARGIN_LEFT'].to_i || 0

      y = x.collage(
        @event.print_image_width,
        @event.print_image_height,
        margin_top,
        margin_right,
        margin_bottom,
        margin_left
      )
      y.overlay(print_logo_path)
      y.write(gif_printing_path)
      @photoset.printing_path = PNS.path_relative_to_project(gif_printing_path)
  end

end

