module ShareModalStylesheet
  include ModalStylesheet

  def again_frame
    {t: 422, w: 512, h: 18, l:0}
  end

  def done_frame 
    {t: 422, w: 512, h: 18, l: 512}
  end

  def share_modal(st)
    modal_style st
  end

  def share_modal_main_label st
   st.frame = {t: 350, w: 1024, h: 52}
   st.text_alignment = :center
    st.color = color.white
    st.font = font.with_name("Nobel-Black", 52)
    st.text = "THX FOR SHARING."
  end

  def share_modal_again_label st
   st.frame = again_frame 
    st.text_alignment = :center
    st.color = color.white
    st.font = font.with_name("Nobel-Book", 18)
    st.text = "SHARE AGAIN"
  end

 def share_modal_done_label st
   st.frame = done_frame
   st.text_alignment = :center
    st.color = color.white
    st.font = font.with_name("Nobel-Book", 18)
    st.text = "DONE"
 end 

 def share_modal_again_button st
   st.frame = again_frame
 end
 
 def share_modal_done_button st
   st.frame = done_frame
 end


end
