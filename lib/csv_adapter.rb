require 'csv'

class CSVAdapter

  def initialize(file_name, header)
    @file_name = file_name
    @header = header
  end

  def array_of_strings
    strings = []
    CSV.foreach(@file_name, :headers => true) do |row|
      strings << row[@header]
    end
    return strings
  end
end
