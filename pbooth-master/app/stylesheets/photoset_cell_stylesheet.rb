module PhotosetCellStylesheet

  # If we the event supports multiple orientations then we make the cell a square otherwise we make it a rectangle with a  preset aspect ratio.
  #
  def aspect_ratio
    Event.multiple_orientations ? 1 : Event.image_ratio
  end

  def image_width
    aspect_ratio < 1 ? 242: 326
  end

  def image_height
    image_width / aspect_ratio
  end

  def cell_size
    { w: image_width, h: image_height }
  end

  def image_size
    { w: cell_size[:w] -10, h: cell_size[:h] -10 }
  end

  def photoset_cell(st)
    st.frame = cell_size
    st.layer.borderColor = color.from_rgba(0, 174, 239, 1).CGColor
    st.layer.borderWidth = 0
    st.background_color = color.black
  end

  def selected_photoset_cell st
    photoset_cell st
    st.layer.borderWidth = 5
    st.background_color = color.black
  end

  def image(st)
    st.frame = cell_size
    st.alpha = 1
    st.masks_to_bounds = true
  end

  def selected_image st
    image st
    st.alpha = 0.5
  end

end
