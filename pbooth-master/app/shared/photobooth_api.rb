class PhotoboothAPI

  DEFAULT_SERVER_URL = "http://localhost:3000/"

  class << self

    def server_url
      # Get the server url from settings or if is not valid use a default
      URI.validate_url(Settings.server_url) || DEFAULT_SERVER_URL
    end

    def server_url=(url)
      @@server_url = url
    end

  end
end
