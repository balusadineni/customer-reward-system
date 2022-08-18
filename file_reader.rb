class FileReader
  attr_reader :file

  def initialize(file)
    @file = File.open(file, 'r')
  end

  def content
    @content ||= File.readlines(file).map(&:chomp).map(&:strip)
  end
end
