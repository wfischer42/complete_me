require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require './lib/csv_adapter'

class CSVAdapterTest < Minitest::Test

  def test_it_exists
    adapter = CSVAdapter.new("filename", "header")
    assert_instance_of CSVAdapter, adapter
  end

  def test_it_returns_array_of_strings_from_csv
    file = "./data/addresses_tiny_sample.csv"
    header = "FULL_ADDRESS"
    adapter = CSVAdapter.new(file, header)
    strings = adapter.array_of_strings
    all_strings = strings.all? do |string|
      string.class == String
    end

    assert_instance_of Array, strings
    assert all_strings
  end

  def test_it_returns_correct_values
    file = "./data/addresses_tiny_sample.csv"
    header = "FULL_ADDRESS"
    adapter = CSVAdapter.new(file, header)
    strings = adapter.array_of_strings

    expected = ["2679 S Dayton Way",
                "2679 S Dayton Way Spc D-1",
                "2669 S Dayton Way Spc D",
                "2527 S Broadway",
                "2669 S Dayton Way Spc A-1"]

    assert_equal expected, strings[0..4]
  end

end
