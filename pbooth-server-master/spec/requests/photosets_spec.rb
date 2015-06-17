require 'rails_helper'

RSpec.describe "Photosets API", :type => :request do

  let(:event) { create(:event_with_gifs) }
  let(:photoset) { event.photosets.first }

  describe "GET /photosets/:id" do
    specify "it returns the photos display image" do
      get "/photosets/#{photoset.id}"
      expect(response.body).to be_identical_to(photoset.get_full_path(:display_path))
    end
  end

  describe "GET /photosets/:id/zoom" do
    specify "it returns the photos display image" do
      get "/photosets/#{photoset.id}/zoom"
      expect(response.body).to be_identical_to(photoset.get_full_path(:branded_path))
    end
  end

  describe "POST /photosets/:id/print" do
    specify "a Photo received a :print message" do
      allow(Print).to receive(:call)
      post "/photosets/#{photoset.id}/print"
      expect(Print).to have_received(:call).with(photoset.get_full_path(:printing_path))
    end
  end

  describe "POST /photosets/:id/share" do

    context "to twitter" do
      specify "with correct parameters" do
        allow(Resque).to receive(:enqueue)
        post "/photosets/#{photoset.id}/share", { share_content: { provider: 'twitter', user_id: 1, message: 'hello world' } }
        expect(Resque).to have_received(:enqueue).with(GifToTwitterJob, '1', photoset.id, 'hello world')
      end
    end

    context "to facebook" do
      specify "with correct parameters" do
        allow(Resque).to receive(:enqueue)
        post "/photosets/#{photoset.id}/share", { share_content: { provider: 'facebook', user_id: 1, message: 'hello world' } }
        expect(Resque).to have_received(:enqueue).with(GifToFacebookJob, '1', photoset.id, 'hello world')
      end
    end
  end

end
