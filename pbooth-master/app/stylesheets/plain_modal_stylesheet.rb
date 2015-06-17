module PlainModalStylesheet
  include ModalStylesheet

  def plain_modal(st)
    modal_style st
  end

  def plain_modal_label st
    st.frame = {t: 350, w: 1024, h: 52}
    st.text_alignment = :center
    st.color = color.white
    st.font = font.with_name("Nobel-Black", 52)
  end

end
