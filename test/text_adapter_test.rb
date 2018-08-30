require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require './lib/text_adapter'

class TextAdapterTest < Minitest::Test

  def test_it_exists
    adapter = TextAdapter.new("filename")
    assert_instance_of TextAdapter, adapter
  end

  def test_it_returns_array_of_strings_from_test
    file = "./data/dictionary_tiny_sample"
    adapter = TextAdapter.new(file)
    strings = adapter.array_of_strings
    all_strings = strings.all? do |string|
      string.class == String
    end

    assert_instance_of Array, strings
    assert all_strings
  end

  def test_it_returns_correct_values
    file = "./data/dictionary_tiny_sample"
    adapter = TextAdapter.new(file)
    strings = adapter.array_of_strings

    expected = ["stud",
                "student",
                "students",
                "studio",
                "pizza"]

    assert_equal expected, strings[0..4]
  end
  
end
