# CreatePhoto contains the logic of creating a photo
# Wants
#   A Photo with a valid original_path
#
class CreatePhoto

  def self.call(*args)
    new(*args).call
  end

  def initialize(photo)

    @photo = photo
    @event = @photo.event
    @full_path = PNS.full_path_from_relative(@photo.original_path)
    @filename = PNS.get_filename(@full_path)
  end

  def call
    puts "CreatePhoto.process_photo #{@photo.id}"
    start_time = Time.now # Lets time this process

    PictureProcessor::Basel.new(@full_path).and_then do |x|
      make_oriented_image(x)
      @photo.original_path = PNS.path_relative_to_project(x.path)
    end.and_then do |x|
      make_branded_image(x)
      @photo.branded_path = PNS.path_relative_to_project(x.path)
      @photo.printing_path = @photo.branded_path
    end.and_then do |x|
      make_display_image(x)
      @photo.display_path = PNS.path_relative_to_project(x.path)
    end

    @photo.validate
    @photo.save

    puts "Done. CreatePhoto.process_photo #{@photo.id} in #{ Time.now.to_f - start_time.to_f } s"
  end

  def make_oriented_image(x)
    original_path = "#{PNS.event_original_path(@event.name)}/#{@filename}.jpg"
    x.orient(@event.orientation)
    x.write(original_path)
  end

  def make_branded_image(x)
    branded_path = "#{PNS.event_branded_path(@event.name)}/#{@filename}.jpg"

    branded_size = [@event.branded_image_width, @event.branded_image_height]
    if @event.multiple_orientations
      x.resize_to_magnitude(*branded_size)
    else
      x.resize(*branded_size)
    end

    logo_path = PNS.fetch_event_logo_path(@event.name, x.orientation)

    x.overlay(logo_path)

    x.write(branded_path)
  end

  def make_display_image(x)
    display_path = "#{PNS.event_display_path(@event.name)}/#{@filename}.jpg"

    display_size = [@event.display_image_width, @event.display_image_height]

    if @event.multiple_orientations
      x.resize_to_fill(*([display_size.max]*2))
    else
      x.resize(*display_size)
    end

    x.write(display_path)
  end

end
