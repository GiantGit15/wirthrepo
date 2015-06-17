class SyncEvents
  def self.call(*args)
    new(*args).call
  end

  def initialize
  end

  def call
    event_names = get_event_names_from_file_system

    # Destroy events that dont exist on FS
    Event.all.each do |event|
      event.destroy unless event_names.include?(event.name)
    end

    # Create events that are on the FS
    event_names.map do |event_name|
      Event.find_or_create_by(name: event_name)
    end
  end

  def get_event_names_from_file_system
    Dir["#{PNS.events_path.to_s}/*/"].map do |event_path|
      PNS.relative_path(event_path, PNS.events_path)
    end
  end

end
