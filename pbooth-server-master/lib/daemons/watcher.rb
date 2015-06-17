#!/usr/bin/env ruby

## Watcher
#
# A daemon using the daemon-rails gem
#
# Every X seconds, scan an event directory and send new files to ImageInput
#
# Keeps an array record of files in the directory and on each pass compares this
# array to the directories files in order to determine new additions.
#
# A noticeable quirk is that the first time new files are discovered,
# they are added to the list an not handed over to ImageInput. The
# purpose of this quirk is to not process already present photos after
# the app is started/restarted.
#
# The watcher process is not supposed to crash. On encountering an error
# it will print the error and move on to the next pass.
#


# You might want to change this
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

class Watcher

  def initialize
    puts "Starting a Watcher. RAILS_ENV=#{ENV['RAILS_ENV']}"
    @timers = Timers.new
    @file_list = []
  end

  # Run a sweep every 2 seconds
  #
  def start
    main_timer = @timers.every(2) { run_once_benchmarked }
    loop { @timers.wait }
  end

  def run_once_benchmarked
    bm = Benchmark.measure { run_once }
    puts "Timer block benchmark: #{bm}" if @mark_new_files
  end

  # Using the latest event, if it is active,
  # get a list of files in the capture folder, compare to the file list and pass new additions to the ImageInput class
  #
  # Currently do nothing for removals
  #
  def run_once
      event = Event.latest
      if event && event.active?
        capture_dir = PNS.event_capture_path(event.name)
        new_file_list = get_file_list(capture_dir).uniq # Get rid of duplicates, because fuck duplicates
        new_files = (new_file_list - @file_list).sort

        p new_files unless new_files.empty?

        unless @file_list.nil? || @file_list.empty?
          @mark_new_files = new_files.count > 0 ? true : false
          new_files.map {|filename| "#{capture_dir}/#{filename}"}.each do |path|
            ImageInput.call(path) if path.match(PNS.photo_regex_string) # Check that the file is a photo before handing it over
          end
        end

        @file_list = new_file_list
      else
        #puts "Latest event (#{event.name}) is not active"
      end
  rescue => e
    puts "Resqueued Error in Watcher"
    p e
    p e.message
    p e.backtrace
  end

  def get_file_list(dir_name)
    File.exists?(dir_name) ? Dir.entries(dir_name).select {|f| !File.directory? f} : []
  end

end

$running = true
Signal.trap("TERM") do
  puts "traped TERM signal"
  $running = false
end

while($running) do

  $watcher = Watcher.new.start

  # Replace this with your code
  #Rails.logger.auto_flushing = true
  #Rails.logger.info "This daemon is still running at #{Time.now}.\n"

  #sleep 10
end

