require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require './lib/importer'
require './lib/csv_adapter'
require './lib/text_adapter'

class BadAdapter
  def array_of_strings
    return "This output is invalid!"
  end
end

class ImporterTest < Minitest::Test

  def setup
    csv_file = './data/addresses_tiny_sample.csv'
    csv_adapter = CSVAdapter.new(csv_file, 'FULL_ADDRESS')
    @csv_importer = Importer.new(csv_adapter)

    text_file = './data/dictionary_tiny_sample'
    text_adapter = TextAdapter.new(text_file)
    @text_importer = Importer.new(text_adapter)
  end

  def test_it_exists
    assert_instance_of Importer, @text_importer
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
    @text_importer.adapter = "This isnt an adapter!"
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

    refute @text_importer.words_valid?(list_1)
    refute @text_importer.words_valid?(list_2)
    refute @text_importer.words_valid?(list_3)
  end

  def test_it_gracefully_fails_with_bad_adapter_output
    @text_importer.adapter = BadAdapter.new
    words = @text_importer.words
    assert_nil words
  end
end
