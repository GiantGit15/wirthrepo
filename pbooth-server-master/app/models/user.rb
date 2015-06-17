class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    user  = where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
    user.access_token = auth["credentials"]["token"]
    user.access_token_secret = auth["credentials"]["secret"]
    #user.access_token_expires_at = Time.at(auth.credentials.expires_at)
    user.save!
    user
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
    end
  end

  def twitter
    if provider == "twitter"
      @twitter ||= Twitter::Client.new(oauth_token: oauth_token, oauth_token_secret: oauth_secret)
    end
  end
end
