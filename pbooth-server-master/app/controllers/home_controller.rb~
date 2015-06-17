class HomeController < ApplicationController

  protect_from_forgery with: :null_sessions

  def settings
    @event = Event.latest
  end

  def signed_in
  end

  def authentication_failure
  end

  def admin
    SyncEvents.call # Ensure we can see all the events n the directory.
    @events = Event.all
    @event = Event.latest
   
#    if @event == nil
#    	@event = Event.new
#    	@event.id = 0
#	  end
  end

end
