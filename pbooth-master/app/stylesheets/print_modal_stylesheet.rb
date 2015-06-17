module PrintModalStylesheet
  include ModalStylesheet


  def print_modal(st)
    modal_style st
  end

  def print_modal_main_label st
   st.frame = {t: 350, w: 1024, h: 52}
   st.text_alignment = :center
    st.color = color.white
    st.font = font.with_name("Nobel-Black", 52)
    st.text = "THX."
    st.alpha = 1
  end

  def print_modal_secondary_label st
   st.frame = {t: 422, w: 1024, h: 18}
   st.text_alignment = :center
    st.color = color.white
    st.font = font.with_name("Nobel-Book", 18)
    st.text = "YOUR PHOTOS ARE COMING OUT NOW"
    st.alpha = 1
  end

end
