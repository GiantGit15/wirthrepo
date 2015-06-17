FactoryGirl.define do
  factory :event do
    name "Event-SOMENUMBER"
    gif_mode false
    photos_in_set 6
    branded_image_width 1200
    branded_image_height 1800
    display_image_width 350
    display_image_height 525
    print_image_width 1200
    print_image_height 1800
    copy_email_subject ""
    copy_email_body ""
    copy_social ""
    copy_twitter ""
    #smugmug_album ""
    multiple_orientations false
    option_smugmug false
    option_facebook false
    option_twitter true
    option_email true
    option_print true

    factory :event_with_photos do
      after(:create) do |event|
        photoset = create(:photoset, event: event)
        5.times do
          create(:photo, photoset: photoset)
        end
      end
    end

    factory :gif_event do
      gif_mode false
      photos_in_set 6

      factory :event_with_gifs do
        after(:create) do |event|
          5.times do
            create(:gif, event: event)
          end
        end
      end
    end


  end
end

