class LoadingModal < UIView

  def rmq_build

    rmq.apply_style :plain_modal

    # Add subviews here, like so:
    #rmq.append(UILabel, :some_label)
    @dark_modal_frame = rmq.append(UILabel, :dark_modal_frame).get
    @main_label = rmq.append(UILabel, :plain_modal_label).hide.get

    @main_label.text = "LOADING"

  end

  def text=(value)
    @main_label.setText(value)
  end

  def show
    rmq(@main_label).hide
    rmq(self).show
    rmq(@main_label).animations.fade_in(delay: 1, duration: 2)
    #rmq(@main_label).animate(
      #delay: 10.0,
    #  animations: lambda{|q|
    #    q.animations.fade_in({duration: 3.0})
    #  }
    #)

  end

  def hide
    rmq(self).hide
    rmq(@main_label).hide
  end


end


# To style this view include its stylesheet at the top of each controller's 
# stylesheet that is going to use it:
#   class SomeStylesheet < ApplicationStylesheet 
#     include LoadingModalStylesheet

# Another option is to use your controller's stylesheet to style this view. This
# works well if only one controller uses it. If you do that, delete the 
# view's stylesheet with:
#   rm app/stylesheets/views/loading_modal.rb
