class GifToFacebookJob

  @queue = :social

  class << self
    include PhotoPathnames

    def perform(user_id, photo_id, message)
      puts "GifToFacebookJob"
      @user = User.find(user_id)

      @graph = Koala::Facebook::API.new(@user.access_token)

      photo = Photoset.find(photo_id)
      #photo_file = File.new( full_path_from_relative(photo.display_path) )
      
      UploadPhotoGetUrl.new.upload_photo(photo) unless photo.url

      url = photo.url
      #message = "#{message} #{url}"

      #@graph.put_picture(photo_path_string , { :message => message, link: photo.url })
     # @graph.put_picture(photo_path_string , { :message => message })

      @graph.put_connections("me", "feed", :link => url, :message => message)

      puts "done facebooking"
    end
  end
end
