module ZoomViewStylesheet

  def zoom_view(st)
    st.frame = view_panel_frame
    st.background_color = color.translucent_black
  end

  def zoom_view_spinner st
     st.center = [ view_panel_frame[:w]/2, view_panel_frame[:h]/2 ]
  end

  def zoom_view_image_view st
    image = rmq(st.view).data
    aspect_ratio = if image
                     image.size.width / image.size.height
                   else
                     Event.image_ratio
                   end
    zoom_view_image_view_with_aspect_ratio(st, aspect_ratio)
  end

  # Dynamic styling. These are not rmq_styles but are called directly. They cannot be used to select views.

  def zoom_view_image_view_with_aspect_ratio(st, aspect_ratio)
    #st.frame = PBUtils.dimensions_fill_to_parent_keep_ratio(aspect_ratio, view_panel_width, view_panel_height)

    if aspect_ratio < 1
      height = view_panel_height
      width = height * aspect_ratio
    else
      width = view_panel_height
      height = width / aspect_ratio
    end
    st.frame = { w: width, h: height }
    st.centered = :both
  end

end
