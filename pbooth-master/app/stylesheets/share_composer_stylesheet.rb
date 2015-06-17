module ShareComposerStylesheet

  def share_composer(st)
    st.frame = view_panel_frame
    st.background_color = my_grey

    # Style overall view here
  end

  def my_grey
    color.from_rgba(105, 106, 108, 1)
  end

  def message_background st
    st.frame = {w: 384, h:151}
    st.top = 100
    st.left = 98
    st.background_color = color.white
  end

  def share_message st
    st.frame = {w: 372, h:143}
    st.top = 108
    st.left = 102
    st.font = font.share_message
  end

  def preview_image_size
    {w: 321, h:462}
  end

  def image_background st
    st.frame = preview_image_size
    st.top = 100
    st.left = 576
    st.background_color = my_grey
  end

  def share_image st
    ratio = Event.image_ratio

    parent_width = preview_image_size[:w]
    parent_height = view_panel_height

    #r = w / h
    #h = w / r

    st.frame = if parent_height < parent_width / ratio
      { h: parent_height, w: parent_height * ratio }
    else
      { h: parent_width / ratio, w: parent_width }
    end

    st.centered = :horizontal
    st.background_color = my_grey
  end

  def share_send_button st
    st.frame = {w: 88, h: 38}
    st.top = 264
    st.left = 290
    st.background_image = image.resource("submit_button.png")
  end
  
  def share_cancel_button st
    st.frame = {w: 88, h: 38}
    st.top = 264
    st.left = 392
    st.background_image = image.resource("cancel_button.png")
  end

end
