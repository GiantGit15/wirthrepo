class ActivityIndicator < UIView

  def rmq_build

    rmq.apply_style :activity_indicator

    # Add subviews here, like so:
    #rmq.append(UILabel, :some_label)
    @message = rmq.append(UILabel, :activity_message).get

    @spinner = rmq.append(UIActivityIndicatorView, :activity_spinner).get
    @spinner.hidesWhenStopped = true
    @spinner.startAnimating

  end

  def set_message message
    @message.text = message
    rmq(self).show
  end

  def clear
    @message.text = ""
    rmq(self).hide
  end

end
