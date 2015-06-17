module PhotosetHeaderStylesheet
  def photoset_header_size
    {w: app_width_less_margin, h: header_height}
  end

  def photoset_header(st)
    st.frame = photoset_header_size
    st.background_color = color.white

    #Style overall view here
  end

end
