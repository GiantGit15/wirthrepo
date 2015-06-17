require 'rails_helper'

RSpec.describe "events API", :type => :request do

  describe "GET /events/settings" do
    # This should provide info on the currently active event

    specify "json response should not be empty" do
      create(:event)

      get "/events/settings"

      json = JSON.parse(response.body)

      expect(json.count).to be > 0

    end

    xit "should have more test" do
    end
  end

  describe "GET /events/:id/photos" do
    # This should provide a list of that events photos or photosets.
    # Note here that 'photos' in the url could mean either.
    #
    # TODO think of a good way to create photos to test here

    specify "we get a json response" do
      event = create(:event)
      event.activate
      get "/events/#{event.id}/photos"

      json = JSON.parse(response.body)

      expect(json).to eq []
    end
  end

end
