class PlainModal < UIView

  def rmq_build

    rmq.apply_style :plain_modal

    # Add subviews here, like so:
    @dark_modal_frame = rmq.append(UILabel, :dark_modal_frame).get
    @main_label = rmq.append(UILabel, :plain_modal_label).get

    rmq(self).on(:tap) do
      rmq(self).remove
    end

  end

  def text=(value)
    @main_label.setText(value)
  end

end
