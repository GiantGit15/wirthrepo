class SettingsController < Formotion::FormController

  def init

    @form ||= Formotion::Form.new({
      persist_as: "app_settings",

      sections: [{
        title: "Settings:",
        rows: [
          {
            title: "Server",
            key: :server,
            placeholder: "http://localhost:8000/",
            type: :string,
            auto_correction: :no,
            auto_capitalization: :none
          }
        ]
      }]
    })
    super.initWithForm(@form)
  end


  def viewDidLoad
    super

    self.title = "Settings"

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemStop,
      target: self,
      action: "close"
    )

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle(
      "Load event settings",
      style: UIBarButtonItemStyleBordered,
      target: self,
      action: "load_from_server"
    )

  end

  def close
    App.delegate.close_settings
  end

  #def update_key key, value
  #  @form.sections.each_with_index do |section, s_index|
  #    section.rows.each_with_index do |row, index|
  #      row.value = value if row.key == key
  #    end
  #  end
  #end

  def load_from_server
    load_settings
    load_branding
  end

  def load_settings
    Event.fetch do |settings|
    end
  end

  def branding_url
    "#{PhotoboothAPI.server_url}/branding/1"
  end

  # Load the brand_upper_left.png
  def load_branding

    AFMotion::Image.get(branding_url) do |result|
      if result.success?
        data = UIImagePNGRepresentation(result.object)
        data.write_to("brand_upper_left_remote.png".document_path) if data
      else
        puts "load_branding did not return an image."
        image_file = "brand_upper_left_remote.png".document_path
        image_file.remove_file! if image_file.file_exists?
      end
    end
  end

end

__END__
