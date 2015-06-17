class Photo

  attr_reader :id

  def self.photos_url
    "#{PhotoboothAPI.server_url}/events/#{Event.id}/photos"
  end

  # fetch a list of photos/gifs for the current event, pass this json list into a block
  #
  def self.fetch(options={}, &block)
    AFMotion::JSON.get(photos_url) do |result|
      if result.success?
        begin
          payload = result.object.flatten
          block.call(payload)
        rescue
          puts "Error in processing server ersponse"
        end
      elsif result.operation.response.statusCode.to_s =~ /40\d/
        puts "Request failed"
      elsif result.failure?
        p result.error.localizedDescription
      end

      options[:completed].call if options[:completed]
    end
  end

  def initialize(id, options={})
    @gif = options[:gif]
    @url = options[:url]
    @id = id
    @selected = false
  end

  def share_type
    @gif ? :gif : :photo
  end

  def toggle_selected
    @selected = !@selected
    puts "photo #{@id} selected? = #{selected?}"
  end

  def selected= val
    @selected = val
  end

  def selected?
    @selected
  end

  # Print simply posts a request the the photos print url.
  #
  def print_photo_url
    "#{PhotoboothAPI.server_url}/#{@url}/print"
  end

  def print
    AFMotion::JSON.post(print_photo_url) do |result|
      if result.success?
      elsif result.operation.response.statusCode.to_s =~ /40\d/
        puts "Request failed"
      elsif result.failure?
        p result.error.localizedDescription
      end
    end
  end

  def display_url
    "#{PhotoboothAPI.server_url}/#{@url}/display"
  end

  def feature_url
    "#{PhotoboothAPI.server_url}/#{@url}/zoom"
  end

  # Sharing
  #

  def share_url
    "#{PhotoboothAPI.server_url}/#{@url}/share"
  end

  def share(data, options={})
    AFMotion::JSON.post(share_url, { share_content: data }) do |result|
      if result.success?
        options[:success].call if options[:success]
      elsif result.operation.response.statusCode.to_s =~ /40\d/
        puts "Request failed"
        options[:failure].call if options[:failure]
      elsif result.failure?
        p result.error.localizedDescription
        options[:failure].call if options[:failure]
      end
    end
  end

end
