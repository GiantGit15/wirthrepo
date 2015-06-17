# This is a Resque worker
# Its is called with Resque.enqueue(CreatePhotoJob, photo_id)
#
class CreatePhotoJob

  @queue = :photos

  def self.perform(photo_id)
    CreatePhoto.call(Photo.find(photo_id))
  end
end

