require 'rails_helper'

RSpec.describe "Photos API", :type => :request do

  let(:event) { create(:event_with_photos) }
  let(:photo) { event.photos.first }

  describe "GET /photos/:id" do
    specify "it returns the photos display image" do
      get "/photos/#{photo.id}"
      expect(response.body).to be_identical_to(photo.get_full_path(:display_path))
    end

    xspecify "with a bad id" do
    end
  end

  describe "GET /photos/:id/zoom" do
    specify "it returns the photos display image" do
      get "/photos/#{photo.id}/zoom"
      expect(response.body).to be_identical_to(photo.get_full_path(:branded_path))
    end
  end

  describe "POST /photos/:id/print" do
    specify "a Photo received a :print message" do
      allow(Print).to receive(:call)
      post "/photos/#{photo.id}/print"
      expect(Print).to have_received(:call).with(photo.get_full_path(:printing_path))
    end
  end

  describe "POST /photos/:id/share" do

    context "to twitter" do
      specify "with correct parameters" do
        allow(Resque).to receive(:enqueue)
        post "/photos/#{photo.id}/share", { share_content: { provider: 'twitter', user_id: 1, message: 'hello world' } }
        expect(Resque).to have_received(:enqueue).with(PhotoToTwitterJob, '1', photo.id, 'hello world')
      end
    end

    context "to facebook" do
      specify "with correct parameters" do
        allow(Resque).to receive(:enqueue)
        post "/photos/#{photo.id}/share", { share_content: { provider: 'facebook', user_id: 1, message: 'hello world' } }
        expect(Resque).to have_received(:enqueue).with(PhotoToFacebookJob, '1', photo.id, 'hello world')
      end
    end
  end

end

