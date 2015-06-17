class ShareModal < UIView

  def rmq_build

    rmq.apply_style :share_modal

    @dark_modal_frame = rmq.append(UILabel, :dark_modal_frame).get
    @main_label = rmq.append(UILabel, :share_modal_main_label).get
    @again_label = rmq.append(UILabel, :share_modal_again_label).get
    @done_label = rmq.append(UILabel, :share_modal_done_label).get

    @again_button = rmq.append(UIButton, :share_modal_again_button).on(:tap) do
      rmq.view_controller.dissmiss_share_modal(:share_again)
    end.get

    @done_button = rmq.append(UIButton, :share_modal_done_button).on(:tap) do
      rmq.view_controller.dissmiss_share_modal(:done)
    end.get

  end

  def start
    rmq(self).fade_in
  end

end
