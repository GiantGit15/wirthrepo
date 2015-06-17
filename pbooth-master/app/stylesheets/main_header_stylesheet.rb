module MainHeaderStylesheet
  def main_header_size
    {w: app_width, h: header_height}
  end

  def main_header(st)
    st.frame = main_header_size
    st.background_color = color.white
  end

  def brand_upper_left st
    st.frame = {w: 400, h: 104}
    st.top = 0
    st.left = margin
  end

  def brand_image st
    st.frame = {w: 400, h: 104}
  end

  def icons_container(st)
    st.frame = { w: 500, h: 56, fr: margin, centered: :vertical }
  end

  def mode_icon_size
    { w: 56, h: 56 }
  end

  def mode_icon_styles(st, bg_image)
    st.frame = mode_icon_size
    st.background_image = image.resource(bg_image)
  end

  # Print mode icons

  def refresh_icon st
    st.frame = { w: 44, h: 44, centered: :vertical }
    st.background_image = image.resource("icons/refresh-icon.png").scale_to([44, 44])
  end

  def print_icon(st)
    mode_icon_styles(st, "icons/print-icon.png")
  end

  def email_icon(st)
    mode_icon_styles(st, "icons/email-icon.png")
  end

  def instagram_icon(st)
    mode_icon_styles(st, "icons/instagram-icon.png")
  end

  def facebook_icon(st)
    mode_icon_styles(st, "icons/facebook-icon.png")
  end

  def twitter_icon(st)
    mode_icon_styles(st, "icons/twitter-icon.png")
  end

  def skip_icon(st)
    mode_icon_styles(st, "icons/skip-icon.png")
  end

end
