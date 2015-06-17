# The flow for sharing over twitter or facebook is not terribly
# straightforward. It goes like this
#
# 1) User click the facebook or twitter icon and the SharesController is
# opened
# 2) A UIWebview is opened and /auth/twitter is loaded. This redirects
# to an authentication page by (facebook/twitter)
# 3) On successfull authentication the webview is redirected to
# /signed_in/:id where :id is the user_id which we store.
# 4) ON unsuccessfull authentication the user is directed to
# /authentication_failure which we detect and shut things down.
# 5) After a authenticating, A ShareComper view is opened and the user
# creates their message and clicks send
# 6) We call the photo.share method, which hits /photos/:id/share and
# passes in the user_id as a parameter. The server the looks up in its
# db the auth details for that user_id and sends the content to
# facebook/twitter


module WebViewShareable
  ##
  # requires from the including class:
  #
  #   instance variables:
  #
  #     @photo
  #
  #   methods:
  #
  #     close
  #     finished_sharing

  # Methods to overwrite

  def finished_sharing
    puts "this method should be overwritten"
  end

  def close
    puts "this methods should be overwritten"
  end

  # To be called in viewDidLoad

  def setup_webview

    @webview = rmq.append(UIWebView, :web_view).hide.get.tap do |q|
      q.delegate = self
      q.scrollView.scrollEnabled = true
      q.scrollView.bounces = false
    end
  end

  # Sharing logic

  def start_webview_share(provider)
    @provider = provider || ""
    SVProgressHUD.show
    get_auth
  end

  def get_auth
    url = NSURL.URLWithString("#{Settings.server_url}/auth/#{@provider.downcase}")
    request = NSURLRequest.requestWithURL(url)
    @webview.loadRequest(request)
  end


  def webView(inWeb, shouldStartLoadWithRequest: inRequest, navigationType: inType)
    if authentication_success?(inRequest)
      @user_id = get_user_id_from_successful_auth_url(inRequest)
      kill_webview
      open_share_composer
      false
    else
      if authentication_failure?(inRequest)
        kill_webview
        close
        false
      else
        true
      end
    end
  end

  # return a true if the webview is directed to a particular url indicating a successfull authentication, false otherwise
  def authentication_success?(request)
    matched = request.URL.absoluteString.match("#{Settings.server_url}/?signed_in/(.*)/done")
    matched ? true : false
  end

  def get_user_id_from_successful_auth_url(request)
    matched = request.URL.absoluteString.match("#{Settings.server_url}/?signed_in/(.*)/done")
    matched[1]
  end

  # true if  the webview is directed to a particular url indicating an auth failure
  def authentication_failure?(request)
    matched = request.URL.absoluteString.match("#{Settings.server_url}/?authentication_failure")
    matched ? true : false
  end

  def webViewDidFinishLoad(webView)
    SVProgressHUD.dismiss
    show_webview
  end

  def open_share_composer
    @share_composer = rmq.append(ShareComposer).get
    @share_composer.provider = @provider
    @share_composer.set_photo(@photo)
    if @provider.downcase == "twitter"
      @share_composer.set_message(Event.copy_twitter)
    else
      @share_composer.set_message(Event.copy_social)
    end
  end

  def send_share(message)

    @photo.share({ message: message, provider: @provider.downcase, user_id: @user_id })

    finished_sharing
  end

  def webview
    @webview
  end

  def show_webview
    rmq(@webview).show
  end

  def kill_webview
    rmq(@webview).hide
    App.delegate.clear_cookies
  end
end
