class ZoomView < UIView

  attr_reader :image_view

  def rmq_build

    rmq.apply_style :zoom_view

    @image_view = rmq.append(UIImageView, :zoom_view_image_view).get
    @spinner = rmq.append(UIActivityIndicatorView, :zoom_view_spinner).get
    @spinner.hidesWhenStopped = true

    rmq(self).on(:tap) do |sender|
      close
    end

  end

  def open_photo(photo)
    @photo = photo
    @image_view.image = nil

    rmq(self).animations.fade_in

    @spinner.startAnimating

    @image_view.setImageWithURL(
      @photo.feature_url,
      completed: lambda{ |image, error, cacheType|
        @spinner.stopAnimating
        # Re style @image_view and size according to the image
        rmq(@image_view).reapply_styles
      }
    ) unless @photo.id.nil?
  end

  def close
    rmq.view_controller.deselect_all
    rmq(self).animations.fade_out
    @image_view.cancelCurrentImageLoad
    @image_view.image = nil
    @photo = nil
  end

end
