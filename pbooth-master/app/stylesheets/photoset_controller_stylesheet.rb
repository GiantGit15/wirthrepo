class PhotosetControllerStylesheet < ApplicationStylesheet


  include MainHeaderStylesheet
  include PhotosetCellStylesheet
  include PhotosetHeaderStylesheet
  include PhotosetFooterStylesheet
  include PlainModalStylesheet
  include PrintModalStylesheet
  include ZoomViewStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def collection_view(st)
    st.view.contentInset = [0, margin, 0, margin]
    st.background_color = color.white

    st.view.collectionViewLayout.tap do |cl|
      st.frame = {t: header_height, fb: 0}
      cl.itemSize = [cell_size[:w], cell_size[:h]]
      #cl.scrollDirection = UICollectionViewScrollDirectionHorizontal
      #cl.headerReferenceSize = [photoset_header_size[:w], photoset_header_size[:h]]
      cl.minimumInteritemSpacing = inter_item_spacing
      cl.minimumLineSpacing = inter_item_spacing
      #cl.sectionInsert = [0,0,0,0]
    end
  end

  def main_footer st
    st.frame = { w: app_width, h: footer_height, t: app_height - footer_height }
    st.background_color = color.white
  end

  def mail_composer st
    st.frame = view_panel_frame
  end

  def loading_splash st
    st.frame = { w: app_width, h: app_height  }
    st.background_color = color.black
    st.z_position = 1000
  end


end
