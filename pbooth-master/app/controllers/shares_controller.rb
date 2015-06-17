# Initialize with a 'photo' and a 'share_type'. This controller is responsible for
# sharing the photo to twitter,facebook or email and then directing back
# to the main controller.
#

class SharesController < UIViewController
  include EmailShareable
  include WebViewShareable

  attr_accessor :parent_controller

  def initialize(photo, share_type)
    @photo = photo
    @share_type = share_type
  end

  def viewDidLoad
    super

    rmq.stylesheet = SharesControllerStylesheet
    rmq(self.view).apply_style :root_view

    @header = rmq.append(MainHeader, :main_header).get
    @header.create_icons([:skip])
    @share_modal = rmq.append(ShareModal, :share_modal).hide.get

    # From WebViewShareable
    setup_webview
  end

  # Remove if you are only supporting portrait
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end

  def viewDidAppear(animated)
    start_sharing(@share_type)
  end

  def start_sharing(share_type)
    case share_type
    when "Email"
      # From EmailShareable
      start_email_share
    when "Twitter"
      # From WebViewShareable
      start_webview_share("twitter")
    when "Facebook"
      # From WebViewShareable
      start_webview_share("facebook")
    end
  end

  def close
    @photo = nil
    @share_type = nil
    SVProgressHUD.dismiss
    navigationController.popViewControllerAnimated(false)
  end

  def sharerFinishedSending sharer
    show_share_modal
  end

  def finished_sharing
    rmq(@share_modal).animations.fade_in
  end

  # We can do two things here, close this controller and go back to the open photo in the main controller or reset the state in the main controller.
  #
  def dissmiss_share_modal(result)
    rmq(@share_modal).hide

    if result == :done && self.parent_controller.respond_to?(:clean_slate)
      self.parent_controller.clean_slate
    end

    close
  end
end

__END__
