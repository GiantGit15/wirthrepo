class MainHeader < UIView

  attr_reader :reused
  attr_accessor :delegate

  ICONS = [ :refresh, :print, :email, :facebook, :twitter, :instagram, :skip ]

  def rmq_build

    @icons = []

    rmq(self).apply_style :main_header

    @brand = rmq.append(UIButton, :brand_upper_left).on(:tap, {taps_required: 4}) do |sender|
      rmq.view_controller.open_settings
    end.get

    rmq(@brand).tap do |b|
      @brand_img = b.append(UIImageView, :brand_image).get

      img = if "brand_upper_left_remote.png".document_path.file_exists?
              UIImage.imageWithContentsOfFile("brand_upper_left_remote.png".document_path)
            else
              UIImage.imageNamed("brand_upper_left")
            end

      @brand_img.image = img
    end

    @icons_container = rmq.append(UIView, :icons_container).get

  end

  def create_icons(icons)
    icons.select{ |icon| ICONS.include?(icon) }.each_with_index do |icon, order_from_right|
      self.send("create_#{icon}_icon", order_from_right)
    end

    disable_or_enable_icons(false)
  end

  #def disable_icons_for_webview
  #  [@print_icon, @email_icon, @instagram_icon, @facebook_icon, @twitter_icon].compact.each do |i|
  #    i.enabled = false
  #  end
  #end

  def disable_or_enable_icons(something_selected)
    @icons.select{ |icon| icon.disable_when_nothing_is_selected }.each do |i|
      i.enabled = something_selected
    end
  end

  def load_branding(img)
    @brand_img.image = img
  end

  # Methods for building icons

  def create_refresh_icon(order)
    icon = rmq(@icons_container).append(IconButton, :refresh_icon).on(:tap) do |sender|
      puts "refresh clicked"
      rmq.view_controller.refresh_signout_clear_jump
    end.get
    icon.order_from_right = order
    icon.disable_when_nothing_is_selected = false
    @icons << icon
  end

  def create_print_icon(order)
    icon = rmq(@icons_container).append(IconButton, :print_icon).on(:tap) do |sender|
      puts "print_icon clicked"
      rmq.view_controller.print_selected
    end.get
    icon.order_from_right = order
    icon.disable_when_nothing_is_selected = true
    @icons << icon
  end

  def create_email_icon(order)
    icon = rmq(@icons_container).append(IconButton, :email_icon).on(:tap) do
      puts "email_icon clicked"
      rmq.view_controller.share_photo("Email")
    end.get

    icon.order_from_right = order
    icon.disable_when_nothing_is_selected = true
    @icons << icon
  end

  def create_instagram_icon(order)
    icon = rmq(@icons_container).append(IconButton, :instagram_icon).on(:tap) do
      puts "instgram_icon clicked"
      rmq.view_controller.share_photo("Instagram")
    end.get

    icon.order_from_right = order
    icon.disable_when_nothing_is_selected = true
    @icons << icon
  end

  def create_facebook_icon(order)
    icon = rmq(@icons_container).append(IconButton, :facebook_icon).on(:tap) do
      puts "facebook_icon clicked"
      rmq.view_controller.share_photo("Facebook")
    end.get

    icon.order_from_right = order
    icon.disable_when_nothing_is_selected = true
    @icons << icon
  end

  def create_twitter_icon(order)

    icon = rmq(@icons_container).append(IconButton, :twitter_icon).on(:tap) do
      puts "twitter_icon clicked"
      rmq.view_controller.share_photo("Twitter")
    end.get

    icon.order_from_right = order
    icon.disable_when_nothing_is_selected = true
    @icons << icon
  end
  
  def create_twitter_icon(order)

    icon = rmq(@icons_container).append(IconButton, :twitter_icon).on(:tap) do
      puts "twitter_icon clicked"
      rmq.view_controller.share_photo("Twitter")
    end.get

    icon.order_from_right = order
    icon.disable_when_nothing_is_selected = true
    @icons << icon
  end
  
  def create_skip_icon(order)

    icon = rmq(@icons_container).append(IconButton, :skip_icon).on(:tap) do
      puts "skip_icon clicked"
      rmq.view_controller.close
    end.get

    icon.order_from_right = order
    icon.disable_when_nothing_is_selected = false
    @icons << icon
  end

  ##
end

