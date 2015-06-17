module EmailShareable

  def finished_sharing
    puts "this method should be overwritten"
  end

  def close
    puts "this methods should be overwritten"
  end

  def start_email_share
    SVProgressHUD.show

    fetch_image_then do |image|
      compose_email(image)
    end
  end

  def fetch_image_then(&block)
    manager = SDWebImageManager.sharedManager

    manager.downloadWithURL(
      @photo.feature_url,
      options: 0,
      progress: lambda { |received_size, expected_size| },
      completed: lambda do | image, error, cache_type, finished |
        block.call(image) if image
      end
    )
  end


  def compose_email(image)

    unless MFMailComposeViewController.canSendMail
      p "Cannot send mail"
      close
      return
    end

    rmq.app.delegate.mailController = nil
    rmq.app.delegate.mailController = MFMailComposeViewController.alloc.init

    unless rmq.app.delegate.mailController
      NSLog("mailController is nil")
      return
    end

    rmq.app.delegate.mailController.mailComposeDelegate = self

    # Title and body

    rmq.app.delegate.mailController.setSubject(Event.copy_email_subject || "")

    rmq.app.delegate.mailController.setMessageBody(
      Event.copy_email_body || "",
      isHTML: false
    )


    # Add the image

    if image
      if image.duration > 0

        data = AnimatedGIFImageSerialization.animatedGIFDataWithImage(
          image,
          duration:image.duration,
          loopCount:0,
          error:nil
        )

        rmq.app.delegate.mailController.addAttachmentData( data, mimeType: "image/gif", fileName: "P#{@photo.id}.gif")
      else
        rmq.app.delegate.mailController.addAttachmentData(
          UIImageJPEGRepresentation(image, 1),
          mimeType: "image/jpeg",
          fileName: "P#{@photo.id}.jpg"
        )
      end
    end

    self.presentModalViewController(rmq.app.delegate.mailController, animated:true)

    SVProgressHUD.dismiss
  end

  def mailComposeController( controller, didFinishWithResult: result, error: error )
    SVProgressHUD.dismiss

    controller.dismissModalViewControllerAnimated(
      false,
      completion: lambda {
        #rmq.app.delegate.recycleMailController
      }
    )

    case result
    when MFMailComposeResultSent
      finished_sharing
    when MFMailComposeResultSaved
      close
    when MFMailComposeResultCancelled
      close
    when MFMailComposeResultFailed
      close
    else
      close
    end
  end

end
