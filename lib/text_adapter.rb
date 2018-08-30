class TextAdapter
  attr_accessor :filename
  
  def initialize(filename)
    @filename = filename
  end

  def array_of_strings
    dictionary = File.read(@filename)
    dictionary.split("\n")
  end

end
