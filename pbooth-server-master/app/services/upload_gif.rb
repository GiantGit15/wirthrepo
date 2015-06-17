# Upload a gif to smugmug, receive a URL back and save this onto the
# photoset model
#

class UploadGif

  def self.call(*args)
    new(*args).call
  end

  def initialize(photoset_id)
    @photoset = Photoset.find(photoset_id)

    @album_title = @photoset.event.smugmug_album || ENV["SMUGMUG_ALBUM_TITLE"]

    @smugmug_client ||= SmugMug::Client.new(
      api_key: ENV["SMUGMUG_KEY"],
      oauth_secret: ENV["SMUGMUG_SECRET"],
      user: { token: ENV["SMUGMUG_ACCESS_TOKEN"],
              secret: ENV["SMUGMUG_ACCESS_SECRET"] }
    )

  end

  def call
    puts "upload_gif"

    album_id = get_smugmug_album_id

    data = smugmug_client.upload_media(
      :file => PNS.full(@photoset.branded_path),
      :AlbumID => album_id
    )

    p data

    url = shorten_url(data["URL"])

    @photoset.url = url
    @photoset.save
  end

  def get_smugmug_album_id

    return $album_id if $album_id

    puts "fething album id for Title=#{@album_title}"

    albums = @smugmug_client.albums.get
    album = albums.select { |i| i["Title"] == @album_title }.first
    if album
      $album_id = album["id"]
    else
      raise "Could not find smugmug album for Title=#{@album_title}"
    end

    $album_id
  end

  # Use Bitly to get a short URL
  def shorten_url(url)
    puts "shorten_url"
    bitly = Bitly.client
    u = bitly.shorten(url)
    u.short_url
  end
end
