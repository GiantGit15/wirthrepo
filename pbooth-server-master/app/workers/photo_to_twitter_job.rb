class PhotoToTwitterJob

  @queue = :social

#class PhotoToTwitterJob < ActiveJob::Base
#  queue_as: :social

  def self.perform(user_id, photo_id, message)
    PhotoToTwitter.call(user_id, photo_id, message)
  end

end
