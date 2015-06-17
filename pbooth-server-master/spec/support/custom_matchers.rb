RSpec::Matchers.define :be_identical_to do |filename|
  match do |data|
    tempfile = Rails.root.join('spec', 'tmp', 'tempfile')

    File.open(tempfile, 'wb') do |file|
      file.write(data)
    end

    FileUtils.identical?(filename, tempfile)
  end

  # Optional failure messages
  failure_message do |actual|
    "expected data to be equal to file"
  end

  failure_message_when_negated do |actual|
    "expected data not to be equal to file"
  end

  # Optional method description
  description do
    "checks equality of binary data against a file"
  end
end

# Image dimensions
RSpec::Matchers.define :have_dimensions do |*expected|
  match do |path|
    image = Magick::Image.read(path).first
    @expected_size = expected
    @actual_size   = [image.columns, image.rows]
    @expected_size == @actual_size
  end

  failure_message do |actual|
    "expected #{actual} to have an size (width: #{@expected_size[0]}, height: #{@expected_size[1]})"\
    ", got (width: #{@actual_size[0]}, height: #{@actual_size[1]})"
  end

  failure_message_when_negated do |actual|
    "expected #{actual} not to have an size (width: #{@expected_size[0]}, height: #{@expected_size[1]})"\
    ", got (width: #{@actual_size[0]}, height: #{@actual_size[1]})"
  end
end


def show_image_info(file)
  puts file
  img = Magick::Image::read(file).first
  puts "   Format: #{img.format}"
  puts "   Geometry: #{img.columns}x#{img.rows}"
  puts "   Class: " + case img.class_type
  when Magick::DirectClass
    "DirectClass"
  when Magick::PseudoClass
    "PseudoClass"
  end
  puts "   Depth: #{img.depth} bits-per-pixel"
  puts "   Colors: #{img.number_colors}"
  puts "   Filesize: #{img.filesize}"
  puts "   Resolution: #{img.x_resolution.to_i}x#{img.y_resolution.to_i} "+
  "pixels/#{img.units == Magick::PixelsPerInchResolution ?
            "inch" : "centimeter"}"
            if img.properties.length > 0
              puts "   Properties:"
              img.properties { |name,value|
                puts %Q|      #{name} = "#{value}"|
              }
  end
end

