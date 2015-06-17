class IconButton < UIButton

  attr_accessor :max_photos, :min_photos
  attr_accessor :disable_when_nothing_is_selected

  def rmq_build

    #rmq.apply_style :icon_button

    # Add subviews here, like so:
    #rmq.append(UILabel, :some_label)

    me = rmq(self)

    me.on(:touch_down) do
      me.animate(
        duration: 0,
        animations: lambda{|q|
          q.style {|st| st.scale = 1.1}
        }
      ) 
    end
    me.on(:touch_stop) do
      me.animate(
        duration: 0.1,
        animations: lambda{|q|
          q.style {|st| st.scale = 1.0}
        }
      ) 
    end

  end

  def enabled= value
    self.setEnabled value
    if value
      rmq(self).style{|st| st.alpha = 1}
    else
      rmq(self).style{|st| st.alpha = 0.3}
    end
  end

  def order_from_right= (value)
    rmq(self).style do |st|
      st.from_right = value * 78
    end
  end

end
