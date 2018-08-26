require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'
require './lib/node'

class CompleteMeTest < Minitest::Test
  def test_it_exists
    completion = CompleteMe.new

    assert_instance_of CompleteMe, completion
  end

  def test_last_node_of_new_word
    completion = CompleteMe.new
    last_node = completion.insert("pizza")
    assert_equal "pizza", last_node.word
    assert_equal "a", last_node.value
  end

  def test_it_can_detect_if_word_is_present
    completion = CompleteMe.new
    completion.insert("pizza")
    assert completion.include?("pizza")
  end

  def test_detect_if_word_is_absent
    completion = CompleteMe.new
    completion.insert("pizzaria")
    refute completion.include?("pizza")
    refute completion.include?("4i2364876")
  end

  def test_it_can_count_words
    completion = CompleteMe.new
    assert_equal 0, completion.count
    completion.insert("pizza")
    assert_equal 1, completion.count

    completion.insert("dog")
    completion.insert("cat")
    assert_equal 3, completion.count
  end

  def test_it_can_list_lexicon
    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pizzaria")
    completion.insert("dog")

    lexicon = completion.lexicon
    assert lexicon.include?("pizza")
    assert lexicon.include?("pizzaria")
    assert lexicon.include?("dog")
    refute lexicon.include?("cat")
  end

  def test_it_can_suggest_words

    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pize")
    suggestion = completion.suggest("piz")
# ["pize", "pizza", "pizzeria", "pizzicato", "pizzle"]
    assert suggestion.include?("pize")
    assert suggestion.include?("pizza")
  end

  def test_it_deosnt_suggest_unrelated_words
    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pize")
    completion.insert("pokemon")
    suggestion = completion.suggest("piz")
    refute suggestion.include?("pokemon")
  end

  def test_can_populate_from_a_dictionary
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)

    assert_equal 235886, completion.count
    assert completion.include?("tissue")
  end

  def test_can_suggest_many_words_after_population
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    suggestion = completion.suggest("piz")
    expected = ["pize", "pizza", "pizzeria", "pizzicato", "pizzle"]

    assert_equal expected, suggestion
  end

end
