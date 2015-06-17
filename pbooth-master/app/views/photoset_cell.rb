class PhotosetCell < UICollectionViewCell 
  attr_reader :reused

  PLACEHOLDER = "icon-76@2x.png"

  def rmq_build
    rmq(self.contentView).tap do |q|
      @image_view = q.append(UIImageView, :image).get
    end
    apply_style
  end

  def apply_style
    rmq(@image_view).apply_style(:image)
    rmq(self).apply_style :photoset_cell
  end

  def photo=(value)
    @photo = value
    set_image
    apply_style
  end

  def photo_id
    @photo.id
  end

  def set_image
    @image_view.setImageWithURL(@photo.display_url) unless @photo.id.nil?
  end

  def rasterize
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale = UIScreen.mainScreen.scale
  end

  def prepareForReuse
    @reused = true
    @photo = nil
    @image_view.cancelCurrentImageLoad # sdwebimage stuff
    @image_view.image = nil # set it to nil so that errant images don't show up
  end

end
