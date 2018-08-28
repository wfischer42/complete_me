class TextAdapter

  def initialize(file_name)
    @file_name = file_name
  end

  def array_of_strings
    dictionary = File.read(@file_name)
    dictionary.split("\n")
  end

end
