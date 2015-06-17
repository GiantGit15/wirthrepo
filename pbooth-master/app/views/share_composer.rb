class ShareComposer < UIView

  attr_accessor :provider

  def rmq_build

    rmq.apply_style :share_composer

    rmq.append(UIView, :message_background).tap do |v|
      @share_message = rmq.append(UITextView, :share_message).get
    end

    @image_background = rmq.append(UIView, :image_background).tap do |b|
      @image_view = b.append(UIImageView, :share_image).get
    end.get

    @send_button = rmq.append(UIButton, :share_send_button).on(:tap) do

      if provider == "twitter" &&  @share_message.text.size > 120
        App.alert("a maximum of a 120 characters please")
      else
        rmq.view_controller.send_share(@share_message.text)
        rmq(self).remove
      end
    end.get

    @cancel_button = rmq.append(UIButton, :share_cancel_button).on(:tap) do
      rmq(self).remove
    end.get

  end

  def set_photo(photo)
    unless photo.nil?
      @image_view.setImageWithURL(
        photo.feature_url,
        completed: lambda do |image, error, cacheType|
          # Re style @image_view and size according to the image
          #rmq(@image_view).reapply_styles
        end
      )
      @photo = photo
    end
  end

  def set_message message
    @share_message.text = message
  end

end
