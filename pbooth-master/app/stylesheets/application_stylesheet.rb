class ApplicationStylesheet < RubyMotionQuery::Stylesheet

  def application_setup

    # An example of setting up standard fonts and colors
    font_family = 'Helvetica Neue'

    font.add_named :large,    font_family, 36
    font.add_named :medium,   font_family, 24
    font.add_named :small,    font_family, 18 

    font.add_named :share_message,  "Nobel-Book", 18

    font.add_named :activity_indicator,  "Nobel-Book", 24

    color.add_named :translucent_black, color.from_rgba(0, 0, 0, 0.8)
    color.add_named :battleship_gray,   '#7F7F7F' 

    #
    font_family = "Chalkboard SE"
    font.add_named :chalk, font_family, 24

  end

  def app_width
    1024
  end

  def app_height
    768
  end

  def header_height
    104
  end

  def footer_height
    14
  end

  def margin
    14
  end

  def inter_item_spacing
    9
  end

  def app_width_less_margin
    app_width - 2 * margin
  end

  def app_frame
    { w: app_width, h: app_height }
  end

  # View panel

  def view_panel_width
    app_width - 2*margin
  end

  def view_panel_height
    app_height - header_height - footer_height
  end

  def view_panel_top
    header_height
  end

  def view_panel_left
    margin
  end

  def view_panel_size
    { w: view_panel_width, h: view_panel_height  }
  end

  def view_panel_frame
    # 996, 768
    { w: view_panel_width, h: view_panel_height , t: view_panel_top, l: view_panel_left }
  end

end
