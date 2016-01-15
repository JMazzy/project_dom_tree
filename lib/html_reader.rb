class HTMLReader
  attr_accessor :file
  attr_reader :html

  FILE_SPLIT_REGEX = /(<\/*[^<>\/]*>)/

  def initialize
    @file = file
    @html = nil
  end

  def convert_file
    open_file = File.open(@file, "r")
    file_array = []
    open_file.readlines.each do |line|
      file_array << line.strip
    end
    open_file.close
    @html = file_array.join.split( FILE_SPLIT_REGEX ) - [""]
  end
end
