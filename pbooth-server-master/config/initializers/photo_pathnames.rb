
module PhotoPathnames
  # Photo paths are saved relative to the project root. This is so that
  # the project can be transfered to another local eg another backup
  # machine
  #
  def project_path
    ENV["PROJECT_ROOT"]
  end

  # Events path, full.
  #
  def events_path
    ENV["EVENTS_PATH"]
  end

  # Print localtion, For all events
  #
  def print_path
    ENV["PRINT_PATH"]
  end

  def photos_path_relative
    "Capture"
  end

  def photos_processed_path_relative
    "Processed"
  end

  def photo_regex_string
     # "#{events_path.to_s}/(?<event>.*)\/#{ photos_path_relative }\/.*\.(jpg|JPG)"
    "#{events_path}/(?<event>.*)\/(Capture|Archive)\/(?<filename>.*)\.(jpg|JPG)$"
  end

  # Methods with arguments
  
  def relative_path(path, from_path)
      Pathname.new(path).relative_path_from(Pathname.new(from_path)).to_s
  end

  def path_relative_to_project(full_path)
    Pathname.new(full_path).relative_path_from(Pathname.new(project_path)).to_s
  end

  def full_path_from_relative(relative_path)
    "#{project_path}/#{relative_path}"
  end

  # Gives the full path from a relative path. If a full path is passed
  # in it will return it unmodified.
  #
  def full(_path)
    _path.match(project_path) ? _path : "#{project_path}/#{_path}"
  end

  # Specific event path, full.
  #
  def event_path(event_name)
    "#{events_path}/#{event_name}"
  end

  def event_display_path(event_name)
    "#{event_path(event_name)}/#{photos_processed_path_relative}/Display"
  end
  
  def event_branded_path(event_name)
    "#{event_path(event_name)}/#{photos_processed_path_relative}/Branded"
  end
  
  def event_original_path(event_name)
    "#{event_path(event_name)}/#{photos_processed_path_relative}/Original"
  end

  def event_capture_path(event_name)
    "#{event_path(event_name)}/Capture"
  end
  
  def event_archived_path(event_name)
    "#{event_path(event_name)}/Archive"
  end

  ## Branding

  def event_logo_path(event_name, orientation=:none)
    case orientation
    when :portrait
      "#{event_path(event_name)}/Client Logo/logo_portrait.png"
    when :landscape
      "#{event_path(event_name)}/Client Logo/logo_landscape.png"
    else
      "#{event_path(event_name)}/Client Logo/logo.png"
    end
  end

  def only_if_file(path)
    if File.file?(path)
      path
    else
      nil
    end
  end

  # first look for an oriented logo then a generic and hen return nil
  def fetch_event_logo_path(event_name, orientation)
    only_if_file(
      event_logo_path(event_name, orientation)
    ) || only_if_file(
      event_logo_path(event_name)
    )
  end

  def event_print_logo_path(event_name)
    "#{event_path(event_name)}/Client Logo/print_logo.png"
  end


  def branding_path(event_name, n)
    case n
    when "1"
      "#{event_path(event_name)}/Client Logo/brand_upper_left.png"
    else
      ""
    end
  end

  # Utils

  def get_filename(full_path)
      #match = full_path.match("#{events_path}/(?<event>.*)\/#{ photos_path_relative }\/(?<filename>.*)\.(jpg|JPG)")
      match = full_path.match(photo_regex_string)
      match ? match["filename"] : nil
  end

  def get_event_name(full_path)
      match = full_path.match(photo_regex_string)
      match ? match["event"] : nil
  end

end

class PNS
  class << self
    include PhotoPathnames
  end
end
