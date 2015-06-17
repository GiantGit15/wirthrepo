class AppDelegate

  attr_accessor :photoset_controller
  attr_accessor :mailController

  def window
    @window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    clear_cookies

    UIApplication.sharedApplication.setStatusBarHidden(true, animated:false)

    recycleMailController

    @photoset_controller ||= PhotosetController.new
    @navc ||= UINavigationController.alloc.initWithRootViewController(@photoset_controller)
    window.rootViewController = @navc
    window.makeKeyAndVisible
    true
  end

  def clear_cookies
    # Clear cookies
    storage = NSHTTPCookieStorage.sharedHTTPCookieStorage
    storage.cookies.each do |cookie|
      storage.deleteCookie(cookie)
    end
  end

  def open_settings
    @settings_vc = SettingsController.alloc.init
    @settings_nav_controller = UINavigationController.alloc.initWithRootViewController(@settings_vc)
    window.rootViewController = @settings_nav_controller
  end

  def close_settings
    @photoset_controller = PhotosetController.new
    @navc = UINavigationController.alloc.initWithRootViewController(@photoset_controller)
    window.rootViewController = @navc

    @settings_controller = nil
    @settings_nav_controller = nil
  end

  def recycleMailController
    self.mailController = nil # recycle it
    self.mailController = MFMailComposeViewController.alloc.init
  end

  #def applicationDidReceiveMemoryWarning application
  #end

end
