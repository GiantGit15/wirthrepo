class SessionsController < ApplicationController
  layout false

  def create

    begin

      user = User.from_omniauth(auth_hash)
      user.access_token        = auth_hash["credentials"]["token"]
      user.access_token_secret = auth_hash["credentials"]["secret"]

      session[:user_id] = user.id

      notice = Rails.env.development? ? auth_hash.to_s : "Signed in sent"

      puts "hello from sessions create"

      redirect_to signed_in_path(user.id), notice: notice
    rescue
      redirect_to authentication_failure_path
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
