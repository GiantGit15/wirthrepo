class Photoset < ActiveRecord::Base

  belongs_to :event
  has_many :photos, dependent: :destroy

  def self.clear_empties
    self.all.each do |photoset|
      photoset.destroy_if_empty
    end
  end

  def self.fullup_count photos_in_set
    where(photos_count: photos_in_set).size
  end

  def self.valid_count
    where(validated: true).size
  end

  def latest_photo
    photos.order(taken_at: :desc).limit(1).first
  end

  def destroy_if_empty
    self.destroy if self.photos.count == 0
  end

  # An array of all paths that need to be validated
  def all_paths
    [display_path, branded_path, printing_path]
  end

  def get_full_path(path)
    PNS.full_path_from_relative(self.send(path))
  end

  # A photo is valid if its paths lead to actual files
  def validate!
    validate
    save
  end

  def validate
    self.validated = all_paths.map{ |_path| File.file?(PNS.full_path_from_relative( _path )) }.reduce(:&)
  end

  def print
    Print.call( PNS.full_path_from_relative(self.printing_path) )
  end

  def share(data)
    case data[:provider]
    when "twitter"
      puts "sharing to twitter"
      Resque.enqueue(GifToTwitterJob, data[:user_id], id, data[:message])
    when "facebook"
      puts "sharing to facebook"
      Resque.enqueue(GifToFacebookJob, data[:user_id], id, data[:message])
    end
  end
 
end
