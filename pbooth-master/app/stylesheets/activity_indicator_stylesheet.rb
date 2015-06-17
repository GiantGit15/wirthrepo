module ActivityIndicatorStylesheet

  def activity_indicator_size
    { w: 400, h: 200 }
  end

  def activity_indicator(st)
    st.frame = activity_indicator_size
    st.top = (app_height - activity_indicator_size[:h])/2
    st.left = (app_width - activity_indicator_size[:w])/2
    st.background_color = color.translucent_black
    st.z_position = 10000

    # Style overall view here
  end

  def activity_message st
    st.frame = { w: activity_indicator_size[:w], h: activity_indicator_size[:h]/2 }
    st.center = [ activity_indicator_size[:w]/2, activity_indicator_size[:h]/3 ]
    #st.centered = :horizontal
    st.text_alignment = :center
    st.color = color.white
    st.text = "Hello"
    st.font = font.activity_indicator
  end

  def activity_spinner st
    st.center = [ activity_indicator_size[:w]/2, activity_indicator_size[:h]*2/3 ]
  end

end
