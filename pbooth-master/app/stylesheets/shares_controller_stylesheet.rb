class SharesControllerStylesheet < ApplicationStylesheet

  include MainHeaderStylesheet
  include ActivityIndicatorStylesheet
  include ShareComposerStylesheet
  include ShareModalStylesheet

  def setup
  end

  def root_view(st)
    st.background_color = color.white
  end
  
  def web_view st
    st.frame = view_panel_frame
  end


end
