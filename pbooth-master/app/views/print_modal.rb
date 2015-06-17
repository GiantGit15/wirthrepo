class PrintModal < UIView

  def rmq_build

    rmq.apply_style :print_modal

    # Add subviews here, like so:
    #rmq.append(UILabel, :some_label)
    @dark_modal_frame = rmq.append(UILabel, :dark_modal_frame).get
    @main_label = rmq.append(UILabel, :print_modal_main_label).get
    @secondary_label = rmq.append(UILabel, :print_modal_secondary_label).get

  end

end
