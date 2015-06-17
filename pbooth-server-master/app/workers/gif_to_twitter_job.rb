class GifToTwitterJob

  @queue = :social

  class << self
    include PhotoPathnames

    def perform(user_id, photo_id, message)

      @user = User.find(user_id)
      photo = Photoset.find(photo_id)

      twitter_client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV.fetch "TWITTER_KEY"
        config.consumer_secret     = ENV.fetch "TWITTER_SECRET"
        config.access_token        = @user.access_token
        config.access_token_secret = @user.access_token_secret
      end

      # Old way
      # Upload the gif to smug mug then share that link
      #UploadPhotoGetUrl.new.upload_photo(photo) unless photo.url

       message = "#{message} #{photo.url}"
       #twitter_client.update(message)

      photo_file = File.new(PNS.full(photo.branded_path))
      twitter_client.update_with_media(message, photo_file)

      puts "Done tweeting"

    end

  end
end
