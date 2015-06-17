require "rails_helper"

RSpec.describe User, :type => :model do

  describe "associations" do
    it "should have a photoset" do
      event = create(:event_with_photos)
      expect(event.photosets.count).to be 1
      expect(event.photos.count).to be 5
    end
  end

  describe "validations" do

    it "should create using a name only" do
      event = Event.create(name: 'Bloomin Onion')
      expect(event).to be_persisted
    end

    it "should validate the factory versions" do
      expect(create(:event).valid?).to eq true
      expect(create(:gif_event).valid?).to eq true
    end

    def expect_nil_field_to_be_invalid(field)
      event = create(:event)
      event.send("#{field}=", nil)
      expect(event.valid?).to eq false
    end

    xdescribe "invalid" do
      specify "option_whatever should not be nil" do
        [:option_facebook, :option_smugmug, :option_email, :option_twitter].each do |field|
          expect_nil_field_to_be_invalid(field)
        end
      end

      specify "image dimensions should not be nil" do
        [:branded_image_width, :branded_image_height,
         :display_image_width, :display_image_height,
         :print_image_width, :print_image_height].each do |field|
          expect_nil_field_to_be_invalid(field)
        end
      end
    end
  end

  describe "#activate and #deactivate" do
    specify "#activate should set active=true" do
      event1 = create(:event)
      event1.activate
      expect(event1.active).to be true
    end

    specify "#deactivate should set active=false" do
      event1 = create(:event)
      event1.activate
      event1.deactivate
      expect(event1.active).to be false
    end

    specify "#activate should activate itself and deactivate other models" do
      event1 = create(:event)
      event2 = create(:event)

      event1.activate
      event2.activate

      event1.reload

      expect(event2.active).to be true
      expect(event1.active).to be false
    end
  end
end
