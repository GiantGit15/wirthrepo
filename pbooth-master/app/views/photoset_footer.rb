class PhotosetFooter < UICollectionReusableView

  attr_reader :reused

  def rmq_build
    puts "building footer"
    rmq(self).apply_style :photoset_footer

      # Add your subviews, init stuff here
      #@display_label = rmq.append(UILabel.alloc.initWithFrame(self.bounds), :label).get
  end

  def prepareForReuse
    @reused = true
  end

  def display_string=(string)
    @display_label.text = string
  end

end
