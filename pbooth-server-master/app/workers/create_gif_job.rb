# This is a Resque worker
# Its is called with Resque.enqueue(CreateGifJob, photoset_id)
#
class CreateGifJob

  @queue = :photos

  def self.perform( photoset_id )
    CreateGif.call(Photoset.find(photoset_id))
  end
end

