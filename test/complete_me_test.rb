require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'

class CompleteMeTest < Minitest::Test
  def test_it_exists
    completion = CompleteMe.new

    assert_instance_of CompleteMe, completion
  end

  def test_it_can_store_words
    skip
    completion = CompleteMe.new
    completion.insert("pizza")

    assert_equal 1, completion.count
  end

  def test_it_can_suggest_words
    skip
    completion = CompleteMe.new
    completion.insert("pizza")
    suggestion = completion.suggest("piz")

    assert_equal ["pizza"], suggestion
  end

  def test_can_populate_from_a_dictionary
    skip
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)

    assert_equal 235886, completion.count
  end

  def test_can_suggest_many_words_after_population
    skip
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    suggestion = completion.suggest("piz")
    expected = ["pize", "pizza", "pizzeria", "pizzicato", "pizzle"]

    assert_equal expected, suggestion
  end

end
