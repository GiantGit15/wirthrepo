class PictureProcessor

  # Basel and BaselCollection are wrappers around Rmagick and some of
  # its methods. It provides a DSL for image operations as well as an abstraction should we choose to use another library.
  #
  class BaselCollection

    extend Forwardable
    include Enumerable

    def_delegator :@collection, :each
    def_delegator :@collection, :[]
    def_delegator :@collection, :length

    def initialize(paths_or_collection)
      if paths_or_collection.is_a?(BaselCollection)
        @collection = paths_or_collection.map { |basel| Basel.new(basel) }
      else
        @collection = paths_or_collection.map { |path| Basel.new(path) }
      end
    end

  # Pick n evenly spread elements
  # return an array
    def keep(n)
      if n < 1
        []
      elsif length <= n
        self.clone
      else
        stride = (length + (length / n) - 1).to_f / n
        select.with_index do |_, i|
          remainder = i % stride
          (0 <= remainder && remainder < 1)
        end
      end
    end

    # create a new instance, rn the block on it and return that new instance
    def and_then(&block)
      new_instance = self.class.new(self)
      block.call(new_instance) if block
      new_instance
    end

    CHAINABLE_DELEGATE_METHODS = [:orient, :resize, :overlay]

    def method_missing(method_name, *arguments, &block)
      if CHAINABLE_DELEGATE_METHODS.include?(method_name)
        delegate_method_chainable(method_name, *arguments, &block)
      else
        super
      end
    end

    def respond_to?(method_name, include_private = false)
      CHAINABLE_DELEGATE_METHODS.include?(method_name) || super
    end

    def delegate_method_chainable(method_name, *arguments, &block)
      @collection.each{ |x| x.send(method_name, *arguments, &block) }
      self
    end

    def write(out_path, delay=40)
      image_out = Magick::ImageList.new
      @collection.each { |item| image_out << item.image }
      image_out.delay = delay

      create_dir(out_path)
      image_out = image_out.optimize_layers(Magick::OptimizeLayer)
      image_out.write out_path

      self
    end

    def collage(width, height, margin_top, margin_right, margin_bottom, margin_left)

      #test that images are the same size

      sm_width = (width - (margin_right + margin_left))/2
      sm_height = (height - (margin_top + margin_bottom))/2

      geometries = [
        [margin_left, margin_top],
        [sm_width+margin_left, margin_top],
        [margin_top, sm_height + margin_top],
        [sm_width+margin_top, sm_height + margin_top]
      ]

      tile_images = keep(4).map{ |a| a.image }

      image_out = Magick::Image.new(width, height)

      tile_images.each_with_index do |t, i|
        tileimage = t.crop_resized(sm_width, sm_height, Magick::CenterGravity)
        image_out.composite!(tileimage, geometries[i][0], geometries[i][1], Magick::OverCompositeOp)
      end

      Basel.new(image_out)
    end

    # Utils
    def create_dir(filename)
      # Create the directory
      dirname = File.dirname(filename)
      FileUtils.mkdir_p(dirname) unless File.exists?(dirname)
    end

  end

  class Basel

    attr_reader :path
    attr_reader :image

    def initialize(path_or_instance)
      if path_or_instance.is_a?(Basel)
        @image = path_or_instance.image.clone
        @path = nil
      elsif path_or_instance.is_a?(Magick::Image)
        #@image = Magick::ImageList.new
        #@image << path_or_instance
        @image = path_or_instance.clone
        @path = nil
      else
        #@image = Magick::ImageList.new(path_or_instance)
        @image = Magick::Image.read(path_or_instance).first

        @path = path_or_instance
      end
    end

    # create a new instance, rn the block on it and return that new instance
    def and_then(&block)
      new_instance = self.class.new(self)
      block.call(new_instance) if block
      new_instance
    end

    # Properties

    def width
      @image.columns
    end

    def height
      @image.rows
    end

    def aspect_ratio
      @image.columns.to_f / @image.rows
    end

    def orientation
      aspect_ratio <= 1 ? :portrait : :landscape
    end

    # Chainable processing methods

    def write(out_path)
      raise(ArgumentError, "a path is required") if out_path.nil?
      create_dir(out_path)
      @image.write(out_path)
      @path = out_path
      self
    end

    # If nil or :none are passed in we auto_orient
    # If :portrait or :landscape we auto_orient and then rotate
    def orient(force_orientation = nil)
      @image = @image.auto_orient

      if [:portrait, :landscape].include?(force_orientation) && force_orientation != orientation
        @image = @image.rotate(-90)
      end

      self
    end

    def resize(w, h)
      @image = @image.resize(w, h)

      self
    end

    def resize_to_magnitude(m1, m2)
      x_y = case orientation
      when :portrait
        [m1, m2].sort
      when :landscape
        [m1, m2].sort.reverse
      end

      @image = @image.resize(*x_y)

      self
    end

    ##
    # From the RMagick documentation: "Resize the image to fit within the
    # specified dimensions while retaining the aspect ratio of the original
    # image. If necessary, crop the image in the larger dimension."
    #
    # See even http://www.imagemagick.org/RMagick/doc/image3.html#resize_to_fill
    #
    # === Parameters
    #
    # [width (Integer)] the width to scale the image to
    # [height (Integer)] the height to scale the image to
    #
    def resize_to_fill(width, height)
      @image = @image.crop_resized(width, height, Magick::CenterGravity)

      self
    end

    # resize the overlay image to the size of the curent image and composite it
    def overlay(overlay_path)
      if overlay_path && File.file?(overlay_path)
        logo = Magick::ImageList.new(overlay_path).resize!(width, height)
        @image = @image.composite(logo, 0, 0, Magick::OverCompositeOp)
      else
        puts "overlay_path no ta file or nil"
        p overlay_path
      end

      self
    end

    # Utils
    def create_dir(filename)
      # Create the directory
      dirname = File.dirname(filename)
      FileUtils.mkdir_p(dirname) unless File.exists?(dirname)
    end

    def display
      #require "launchy"
      Launchy.open @path
    end

  end


  ## Utils

  #def create_dir(filename)
  #  # Create the directory
  #  dirname = File.dirname(filename)
  #  FileUtils.mkdir_p(dirname) unless File.exists?(dirname)
  #end

  #def self.create_dir(filename)
  #  # Create the directory
  #  dirname = File.dirname(filename)
  #  FileUtils.mkdir_p(dirname) unless File.exists?(dirname)
  #end

  ## Some cameras attach a tag onto the jpg file specifiying which orientation an image should be displayed with.
  ##  This is different from the image file actually having an orientation which is what we desire.
  ##  As such we need strip away this tag - with the auto_orient method.
  ##
  ##


  ## GIFs

  #def create_gif_branded( image_paths, out_path, options={})

  #  create_dir(out_path)

  #  width = options[:width] || ENV["BRANDED_IMAGE_WIDTH"] #350
  #  height = options[:height] || ENV["BRANDED_IMAGE_HEIGHT"] #525

  #  if options[:logo_path] && File.file?(options[:logo_path])
  #    logo = Magick::ImageList.new(options[:logo_path]).resize!(width, height)
  #  end

  #  image_out = Magick::ImageList.new
  #  image_paths.each do |path|
  #    imgl = Magick::ImageList.new(path).resize(width,height)
  #    if options[:logo_path] && File.file?(options[:logo_path])
  #      imgl.composite!(logo, 0, 0, Magick::OverCompositeOp)
  #    end
  #    image_out << imgl
  #  end
  #  #image_out.delay = 40
  #  image_out.delay = ENV["GIF_DELAY"].to_i

  #  image_out.write out_path
  #end

  #def create_gif_display(image_paths, out_path, options={})

  #  create_dir(out_path)

  #  width = options[:width] || ENV["DISPLAY_IMAGE_WIDTH"] #350
  #  height = options[:height] || ENV["DISPLAY_IMAGE_HEIGHT"] #525

  #  # Use first image, resize, no branding
  #  image_out = Magick::ImageList.new(image_paths.first).resize(width,height)

  #  if options[:logo_path] && File.file?(options[:logo_path])
  #    logo = Magick::ImageList.new(options[:logo_path]).resize!(width, height)
  #    image_out.composite!(logo, 0, 0, Magick::OverCompositeOp)
  #  end
  #  # Could brand here
  #  image_out.write out_path

  #end

  #def create_gif_print(image_paths, out_path, options={})

  #  create_dir(out_path)

  #  width = options[:width]
  #  height = options[:height]

  #  #cropped_height = 1350/2 #cropped_height = 1465/2 #cropped_height = 1524/2

  #  cropped_height = options[:cropped_height]

  #  top_margin = 0

  #  sm_width = width/2
  #  sm_height = (height - top_margin)/2

  #  geometries = [
  #    [0,top_margin],
  #    [sm_width,top_margin],
  #    [0,cropped_height + top_margin],
  #    [sm_width, cropped_height + top_margin]
  #  ]


  #  # 4 up even
  #  #sm_width = width/2
  #  #sm_height = height/2

  #  #geometries = [
  #  #  [0,0],
  #  #  [sm_width,0],
  #  #  [0,sm_height],
  #  #  [sm_width, sm_height]
  #  #]

  #  tiles = image_paths.keep(4)

  #  image_out = Magick::Image.new(width, height)

  #  tiles.each_with_index do |t, i|
  #    #tileimage = Magick::ImageList.new(t).resize(sm_width,sm_height)
  #    tileimage = Magick::ImageList.new(t).resize(sm_width,sm_height).crop!(0,0, sm_width, cropped_height)
  #    image_out.composite!(tileimage, geometries[i][0], geometries[i][1], Magick::OverCompositeOp)
  #  end

  #  if options[:logo_path] && File.file?(options[:logo_path])
  #    logo = Magick::ImageList.new(options[:logo_path]).resize!(width, height)
  #    image_out.composite!(logo, 0, 0, Magick::OverCompositeOp)
  #  end

  #  image_out.write out_path

  #end

end
