#
# This class is responsible for coordinating the arrival of an image
# onto the filesystem to its processing in the app.
#
# It expects to receive images syncroniously

class ImageInput

  @@previous_path = ""

  def self.call(*args)
    new(*args).call
  end

  def initialize(path)
    @path = path
  end

  def call

    event_name = PNS.get_event_name(@path)

    mtime = File.mtime(@path) # Modified

    puts "File last modified: #{mtime}"

    taken_at = mtime

    # Move the file out of the capture folder if that is what we are
    # doing.
    if ENV["MOVE_FROM_CAPTURE_FOLDER"] == "YES"
      puts "Moving file from the capture folder"
      new_path = copy_file_to_archive(@path)
      File.delete(@@previous_path) if File.file?(@@previous_path.to_s)
      @@previous_path = @path
      @path = new_path
    end

    ActiveRecord::Base.transaction do
      event = Event.find_or_create_by(name: event_name)
      photoset = get_photoset(event, taken_at)
      # TODO what if this photo already exists?
      photo = photoset.photos.create(original_path: PNS.path_relative_to_project(@path), taken_at: taken_at)
      puts "created photo #{photo.original_path}"

      process_type_loc = process_type(photo, photoset, event)

      puts "process_type: #{process_type_loc}"

      Resque.enqueue(CreatePhotoJob, photo.id) if process_type_loc == "photo"
      Resque.enqueue(CreateGifJob, photoset.id) if process_type_loc == "gif"

    end

  end

  private

  def photoset_full?(photoset, event)
    pcount = photoset.photos.count
    photoset_is_full = (photoset.photos.count >= event.photos_in_set.to_i)
    photoset_is_full
  end

  def process_type(photo, photoset, event)

    if event.gif_mode?
      if photoset_full?( photoset, event )
        "gif"
      else
        "none"
      end
    else
      "photo"
    end
  end

  # Return a photoset, if needed, create a new photoset.
  #
  # A new photoset is created if the event has no photosets or
  # in gif_mode, the current photoset id full or
  # in gif_mode, a period of time has elapsed an the incoing photo is no
  # longer considered as belonging to the previous set.
  #
  def get_photoset(event, taken_at)
    photoset = event.latest_photoset

    if event.gif_mode? && (photoset_full?(photoset, event) || time_has_passed?(photoset, taken_at) )
      puts "need a new photoset"
      photoset = event.photosets.create

      puts "new photoset should be empty.... photoset.photos.count: #{photoset.photos.count}"
    end
    photoset
  end

  def time_has_passed?(photoset, taken_at)
    time_elapsed = time_elapsed_since_last_photo(photoset, taken_at)
    passed = time_elapsed > 2
    puts "time_elapsed_since_last_photo: #{time_elapsed}, #{passed ? 'A suitable amount of time has passed.' : ' still going'}"
    passed
  end

  def time_elapsed_since_last_photo(photoset, taken_at)
    if photoset.photos.count > 0
      latest_photo = photoset.latest_photo
      taken_at.to_f - latest_photo.taken_at.to_f
    else
      0
    end
  end

  # Same filename in the Archive directory
  #
  def get_archived_path(file_path)
    match = file_path.match(PNS.photo_regex_string)
    "#{PNS.event_archived_path( match["event"] )}/#{ match["filename"] }.JPG"
  end

  def copy_file_to_archive(path)
    match = path.match(PNS.photo_regex_string)
    new_path = get_archived_path(path)
    create_dir(new_path)
    FileUtils.cp(path, new_path)
    new_path
  end

  def delete_file(path)
    File.delete path
  end

  def create_dir(filename)
    dirname = File.dirname(filename)
    FileUtils.mkdir_p(dirname) unless File.exists?(dirname)
  end

end

