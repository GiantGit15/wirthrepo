namespace :camera do

  desc "TODO"
  task :check do
    puts "1...2...3"
  end

  desc "TODO"
  task :setup_event  => :environment do

    event_name = "Event-#{Time.now.strftime('%s-%L')}"

    puts "creating event folder"
    FileUtils.mkdir_p(PNS.event_path(event_name))

    puts "creating capture folder"
    FileUtils.mkdir_p(PNS.event_capture_path(event_name))

    puts "creating archive folder"
    FileUtils.mkdir_p(PNS.event_archived_path(event_name))

    puts "creating logo"
    FileUtils.mkdir_p(File.dirname(PNS.event_logo_path(event_name)))
    logo_from = "#{Rails.root}/Test Project/sample_photos/logo.png"
    FileUtils.cp(logo_from, PNS.event_logo_path(event_name))

    puts "creating print logo"
    FileUtils.mkdir_p(File.dirname(PNS.event_print_logo_path(event_name)))
    print_logo_from = "#{Rails.root}/Test Project/sample_photos/print_logo.png"
    FileUtils.cp(print_logo_from, PNS.event_print_logo_path(event_name))

    # Activate the event
    activate_event(event_name)

    puts PNS.event_path(event_name)

  end

  desc "TODO"
  task :latest_event => :environment do
    event = Event.latest
    p event
  end

  desc "TODO"
  task :take_photo => :environment do
    event_name = Event.latest.name
    take_photos(event_name, 1)
  end

  desc "TODO"
  task :take_photos => :environment do

    number_photos = ENV["PHOTOS"] ? ENV["PHOTOS"].to_i : 1
    delay = ENV["DELAY"] ? ENV["DELAY"].to_f : 0.1
    event_name = Event.latest.name
    puts "latest event: #{event_name}"
    take_photos(event_name, number_photos, delay)
  end

  desc "TODO"
  task :take_photos_hard => :environment do

    event_name = Event.latest.name
    puts "latest event: #{event_name}"

    sets = ENV["SETS"] ? ENV["SETS"].to_i : 1

    # Make 5 photosets
    sets.times do
      take_photos(event_name, 2, 0.1)
      sleep(3)
      take_photos(event_name, 11, 0.1) # 1
      sleep(3)
      take_photos(event_name, 20, 0.1) # 2,3,4
      sleep(3)
      take_photos(event_name, 6, 0.1) # 5
    end

  end

  desc "TODO"
  task :take_photos_slowly => :environment do
    event_name = Event.latest.name
    puts "latest event: #{event_name}"
    take_photos(event_name, 6, 3) # 3 second delay
  end

  def activate_event(event_name)
    Event.find_or_create_by(name: event_name).touch
  end

  def take_photos(event_name, number_photos, delay=0)
    puts "delay = #{delay}"
    number_photos.times do
      take_photo(event_name)
      sleep(delay)
    end
  end

  def take_photo(event_name)
    filename = "#{Time.now.strftime('%s-%L')}.JPG"
    photoname = ENV["ORIENTATION"] == "landscape" ? "landscape.JPG" : "portrait.JPG"
    photo_from = "#{Rails.root}/Test Project/sample_photos/#{photoname}"
    photo_to = "#{PNS.event_capture_path(event_name)}/#{filename}"
    puts "creating photo #{photo_to}"

    if ENV["STAMP"].nil?
      temp_file = photo_from
    else
      img = Magick::ImageList.new(photo_from)

      title = Magick::Draw.new
      title.annotate(img, 0,0,0,0, SecureRandom.hex(6)) {
        self.fill = 'black'
        #self.stroke = 'transparent'
        self.pointsize = 200
        self.font_weight = Magick::BoldWeight
        self.gravity = Magick::NorthGravity
      }

      temp_file = "#{Rails.root}/Test Project/sample_photos/tmp.JPG"
      img.write temp_file
    end

    FileUtils.cp(temp_file, photo_to)
  end

end
