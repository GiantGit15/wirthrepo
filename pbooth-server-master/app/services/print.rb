class Print
  #http://www.maclife.com/article/columns/terminal_101_printing_command_line

  def self.call(*args)
    new(*args).call
  end

  def initialize(file_path)
    @file_path = file_path
  end

  def call
    puts "PRINT #{@file_path}"
    if ENV["PRINT_TO_FOLDER"] == "YES"
      print_to_folder
    else
      print_from_system
    end
  end

  def print_to_folder
      # Rename the file to a random string
      # TODO change this format hardcode
      format = "jpg"
      print_to = "#{PNS.print_path}/#{SecureRandom.hex(6)}.#{format}"
      puts "PRINT_TO #{print_to}"
      FileUtils.cp(@file_path, print_to)
  end

  def print_from_system
    system("lpr \"#{@file_path}\"") or raise "lpr failed for #{@file_path}"
  end

end
