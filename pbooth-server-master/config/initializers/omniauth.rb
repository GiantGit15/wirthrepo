#OmniAuth.config.full_host = "http://localhost:3000"

Rails.application.config.middleware.use OmniAuth::Builder do
 # provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"] , {
 #   scope: 'userinfo.email,userinfo.profile,plus.me,https://www.googleapis.com/auth/plus.login,https://picasaweb.google.com/data/'
 # }
  provider :twitter, ENV["TWITTER_KEY"], ENV["TWITTER_SECRET"]

  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], { :scope => "email,user_photos,publish_actions", provider_ignores_state: true }
  provider :smugmug, ENV['SMUGMUG_KEY'], ENV['SMUGMUG_SECRET']
  #provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], {
      #strategy_class: OmniAuth::Strategies::Facebook,
      #provider_ignores_state: true,
  #    scope: "publish_actions"
  #}

end
