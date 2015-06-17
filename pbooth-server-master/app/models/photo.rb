class Photo < ActiveRecord::Base

  belongs_to :photoset, touch: true, counter_cache: true
  delegate :event, :to => :photoset, :allow_nil => true

  def check_validity
    raise "photo.original_path cannot be nil" if self.original_path.nil?
  end

  # An array of all paths that need to be validated
  def all_paths
    [original_path, display_path, branded_path, printing_path]
  end

  # A photo is valid if its paths lead to actual files
  def validate!
    validate
    save
  end

  def validate
    self.validated = all_paths.map{ |_path| File.file?(PNS.full_path_from_relative( _path )) }.reduce(:&)
  end

  def get_full_path(path)
    PNS.full_path_from_relative(self.send(path))
  end

  def print
    Print.call(PNS.full_path_from_relative(printing_path))
  end

  def share(data)
    case data[:provider]
    when "twitter"
      puts "sharing to twitter"
      Resque.enqueue(PhotoToTwitterJob, data[:user_id], id, data[:message])
    when "facebook"
      puts "sharing to facebook"
      Resque.enqueue(PhotoToFacebookJob, data[:user_id], id, data[:message])
    end
  end

end
