class PhotoToFacebookJob

  @queue = :social

  class << self
    include PhotoPathnames

    def perform(user_id, photo_id, message)
      puts "PhotoToFacebookJob"
      @user = User.find(user_id)

      @graph = Koala::Facebook::API.new(@user.access_token)

      photo = Photo.find(photo_id)
      photo_file = File.new( PNS.full_path_from_relative(photo.branded_path) )

      #@graph.put_picture(photo_path_string , { :message => message })
      @graph.put_picture(photo_file , { :message => message })
    end
  end
end
