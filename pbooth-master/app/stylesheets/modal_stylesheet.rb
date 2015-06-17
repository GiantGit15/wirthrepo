module ModalStylesheet

  def modal_style st
    #st.frame = { w: app_width, h: app_height }
    st.frame = app_frame
  end

  def dark_modal_frame st
    st.frame = view_panel_frame
    #st.frame = { w: app_width - 2*margin, h: app_height - header_height - footer_height, t: header_height, l: margin }
    st.background_color = color.from_rgba(0, 0, 0, 0.8)
  end
end
