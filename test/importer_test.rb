require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require './lib/importer'
require './lib/csv_adapter'
require './lib/text_adapter'

class ImporterTest < Minitest::Test

  def setup
    csv_file = './data/addresses_tiny_sample.csv'
    header = "FULL_ADDRESS"
    @csv_importer = Importer.new(csv_file, csv_header: header)

    text_file = './data/dictionary_tiny_sample'
    @text_importer = Importer.new(text_file)

    @default_importer = Importer.new
  end

  def test_it_exists
    assert_instance_of Importer, @text_importer
  end

  def test_it_loads_dictionary_by_default
    assert_instance_of TextAdapter, @default_importer.adapter
    assert_equal '/usr/share/dict/words', @default_importer.adapter.filename
  end

  def test_it_has_correct_adapters
    assert_instance_of TextAdapter, @text_importer.adapter
    assert_instance_of CSVAdapter, @csv_importer.adapter
  end

  def test_validate_adapter
    assert @text_importer.adapter_valid?
    assert @csv_importer.adapter_valid?
  end

  def test_gracefully_fails_with_invalid_adapter
    @text_importer.adapter = "This isnt a valid adapter!"
    assert_nil @text_importer.words
  end

  def test_gracefully_fails_with_invalid_adapter_output
    @text_importer.adapter = "This isnt a valid adapter!"
    assert_nil @text_importer.words
  end

  def test_gets_valid_words
    assert @text_importer.words
    assert @csv_importer.words
  end

  def test_validates_adapter_output
    list = ["Hello", "Goodbye"]
    assert @text_importer.words_valid?(list)
  end

  def test_invalidated_bad_output
    list_1 = {a: 2}
    list_2 = "Hello"
    list_3 = 15
    list = [list_1, list_2, list_3]

    refute @text_importer.words_valid?(list_1)
    refute @text_importer.words_valid?(list_2)
    refute @text_importer.words_valid?(list_3)
    refute @text_importer.words_valid?(list)
  end
end
