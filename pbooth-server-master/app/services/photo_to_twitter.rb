class PhotoToTwitter

  def self.call(*args)
    new(*args).call
  end

  def initialize(user_id, photo_id, message)
    @user_id = user_id
    @photo_id = photo_id
    @message = message
  end

  def call
    puts "PhotoToTwitter(#{@user_id}, #{@photo_id}, #{@message})"

    @user = User.find(@user_id)
    @photo = Photo.find(@photo_id)

    twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch "TWITTER_KEY"
      config.consumer_secret     = ENV.fetch "TWITTER_SECRET"
      config.access_token        = @user.access_token
      config.access_token_secret = @user.access_token_secret
    end

    photo_file = File.new(PNS.full(@photo.branded_path))
    twitter_client.update_with_media(@message, File.new(photo_file))

    puts "Done tweeting"
  end
end
