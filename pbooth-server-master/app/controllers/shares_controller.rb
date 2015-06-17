class SharesController < ApplicationController

  protect_from_forgery with: :null_session
  layout false

  #def twitter
  #  p params

  #  job_klass = case params[:share_contents][:share_type].to_s
  #              when "gif"
  #                GifToTwitterJob
  #              when "photo"
  #                PhotoToTwitterJob
  #              end

  #  Resque.enqueue(
  #    job_klass,
  #    params[:user_id],
  #    params[:share_contents][:photo_id],
  #    params[:share_contents][:message]
  #  )

  #  render "shared.json"
  #end

  #def facebook
  #  job_klass = case params[:share_contents][:share_type].to_s
  #              when "gif"
  #                GifToFacebookJob
  #              when "photo"
  #                PhotoToFacebookJob
  #              end

  #  Resque.enqueue(
  #    job_klass,
  #    params[:user_id],
  #    params[:share_contents][:photo_id],
  #    params[:share_contents][:message]
  #  )

  #  render "shared.json"
  #end

  def smugmug
    client = SmugMug::Client.new(
      api_key: ENV["SMUGMUG_KEY"],
      oauth_secret: ENV["SMUGMUG_SECRET"],
      user: {token: ENV["SMUGMUG_ACCESS_TOKEN"],
             secret: ENV["SMUGMUG_ACCESS_SECRET"]}
    )

    albums = client.albums.get

    redirect_to root_path, notice: albums.to_s
    #render "shared.json"


    #p client.albums
    #p client.albums.get

    #unless $album_id
    #  album_title = ENV["SMUGMUG_ALBUM_TITLE"]
    #  puts "fething album id for Title=#{album_title}"
    #  albums = client.albums.get
    #  album = albums.select{|i| i["Title"] == album_title}.first
    #  if album
    #    $album_id = album["id"]
    #  else
    #    raise "Could not find smugmug album for Title=#{album_title}"
    #  end
    #else
    #  puts "already have album_id"
    #end

    #album_id = "39367211" #Album called "Test"
    #data = client.upload_media(file: "#{Rails.root}/test.gif" , AlbumID: album_id)

    #p data

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  
end
