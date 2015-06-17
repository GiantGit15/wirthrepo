class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def project_path
    @project_path ||= Pathname.new(ENV["PROJECT_ROOT"])
  end

  def events_path
    @events_path ||= Pathname.new(ENV["EVENTS_PATH"])
  end

  def print_path
    @print_path ||= Pathname.new(ENV["PRINT_PATH"])
  end
end
