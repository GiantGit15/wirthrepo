class UploadPhotoGetUrlJob

  @queue = :social

  def self.perform(photoset_id)
    puts "UploadPhotoGetUrlJob"

    UploadGif.call(photoset_id)

    puts "Done. UploadPhotoGetUrlJob"
  end

end
