module PhotosetFooterStylesheet
  def footer_size
    {w: 996, h: 160}
  end

  def photoset_footer(st)
    st.frame = footer_size
    st.background_color = color.gray

    #Style overall view here
  end

end
