# Event is a singleton class. It should not be initiated with :new

class Event

  def self.method_missing(method_name, *arguments, &block)
    event = self.get
    if event && event[method_name.to_s]
      event[method_name.to_s]
    else
      super
    end
  end

  def self.respond_to?(method_name, include_private = false)
    event = self.get
    if event && event[method_name.to_s]
      event[method_name.to_s]
    else
      super
    end
  end

  def self.settings_url
    "#{PhotoboothAPI.server_url}/events/settings"
  end

  # Loads the event settings from the server and persists them.
  # Note that the results are yielded to a block so this is non-blocking.
  #
  def self.fetch(&block)
    AFMotion::JSON.get(settings_url) do |result|
        if result.success?
          begin
            # make nil values and empty string so that we can persist them. This approach is
            # horrible but works.
            data = {}
            result.object.each do |key, value|
              data[key] = value.nil? ? "" : value
            end

            # Store the data
            App::Persistence["event"] = data
            @@data = data

            block.call(data) if block
          rescue
            puts "Error in Photobooth.load_settings block"
          end
        elsif result.operation.response.statusCode.to_s =~ /40\d/
          puts "Request failed"
        elsif result.failure?
          p result.error.localizedDescription
        end
      end
  end

  # Grabs the event settings form the persistence layer.
  def self.get
    App::Persistence["event"]
  end

  def self.icons
    icons = [:refresh]
    event = self.get
    icons << :print if event["option_print"]
    icons << :twitter if event["option_twitter"]
    icons << :facebook if event["option_facebook"]
    icons << :email if event["option_email"]
    icons
  end

  def self.multiple_orientations
    event = self.get
    if event && event["multiple_orientations"] == true
      true
    else
      false
    end
  end

  def self.image_ratio
    event = self.get
    if event
      event["branded_image_width"].to_f / event["branded_image_height"].to_f
    else
      1
    end
  end
end
__END__


  #"branded_image_height" = 1800;
  #  "branded_image_width" = 1200;
  #  "copy_email_body" = "";
  #  "copy_email_subject" = "";
  #  "copy_social" = "";
  #  "copy_twitter" = "";
  #  "created_at" = "2014-12-11T21:16:59.961Z";
  #  "display_image_height" = 525;
  #  "display_image_width" = 350;
  #  "force_orientation" = 1;
  #  "gif_mode" = 1;
  #  "id = 20;"
  #  "multiple_orientations" = 0;
  #  name = "Event-1418332610-393";
  #  "option_email" = "<null>";
  #  "option_facebook" = "<null>";
  #  "option_print" = "<null>";
  #  "option_smugmug" = "<null>";
  #  "option_twitter" = "<null>";
  #  "photos_in_set" = 6;
  #  "print_image_height" = 1800;
  #  "print_image_width" = 1200;
  #  "smugmug_album" = "";
  #  "updated_at" = "2014-12-12T15:02:33.648Z";

