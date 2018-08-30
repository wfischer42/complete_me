require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'

class CompleteMeTest < Minitest::Test
  def setup
    @completion = CompleteMe.new
  end

  def test_it_exists
    assert_instance_of CompleteMe, @completion
  end

  def test_it_has_word_and_address_tries_after_initialization
    assert @completion.tries.keys.include?("words")
    assert @completion.tries.keys.include?("addresses")
  end

  def test_default_trie_is_words
    assert_equal "words", @completion.default
  end

  def test_new_tries_can_be_added
    @completion.add_trie("new_trie")
    assert @completion.tries.keys.include?("new_trie")
  end

  def test_default_trie_can_be_changed
    @completion.add_trie("new_trie")
    @completion.default = "new_trie"
    assert_equal "new_trie", @completion.default
  end

  def test_it_wont_change_default_to_trie_that_isnt_there
    @completion.default = "new_default"
    assert_equal "words", @completion.default
  end

  def test_it_can_insert_words_into_default_trie
    @completion.insert("word")
    assert @completion.include?("word")
  end

  def test_it_wont_detect_words_that_arent_there
    refute @completion.include?("word")
  end

  def test_it_wont_detect_words_in_tries_that_arent_there
    @completion.insert("word", trie_name: "non-tree")
    refute @completion.include?("word", trie_name: "non-tree")
  end

  def test_it_can_count_words_in_default_trie
    assert_equal 0, @completion.count
    @completion.insert("word")
    assert_equal 1, @completion.count
    @completion.insert("another")
    assert_equal 2, @completion.count
  end

  def test_it_can_populate_default_trie
    assert_equal 0, @completion.count
    @completion.populate
    assert_equal 235886, @completion.count
  end

  def test_it_can_populate_from_other_file
    @completion.populate("./data/dictionary_tiny_sample")
    assert @completion.include?("studio")
    assert @completion.include?("pizza")
  end

  def test_it_can_populate_other_trie
    file = "./data/addresses_tiny_sample.csv"
    header = "FULL_ADDRESS"

    address = "3860 N Tennyson St Unit 509"
    @completion.populate(file, csv_header: header, trie_name: "addresses")
    assert @completion.include?(address, trie_name: "addresses")
  end

  def test_it_can_make_suggestions
    @completion.populate("./data/dictionary_tiny_sample")
    suggestions = @completion.suggest("piz")
    assert suggestions.include?("pizza")
  end

  def test_it_can_weight_selections
    @completion.populate("./data/dictionary_tiny_sample")
    @completion.select("piz", "pizza")
    weights = @completion.weight_list

    assert_equal 1, weights[["piz", "pizza"]]
  end

  def test_can_weight_words_based_on_selction
    @completion.populate("./data/dictionary_tiny_sample")
    @completion.select("piz", "pizzeria")
    suggestions = @completion.suggest("piz")
    assert_equal "pizzeria", suggestions[0]
  end

  def test_weights_are_independant
    @completion.populate("./data/dictionary_tiny_sample")
    @completion.select("piz", "pizzeria")
    @completion.select("pi", "pize")
    @completion.select("pizz", "pizza")
    suggestion_1 = @completion.suggest("piz")
    suggestion_2 = @completion.suggest("pi")
    suggestion_3 = @completion.suggest("pizz")
    assert_equal "pizzeria", suggestion_1[0]
    assert_equal "pize", suggestion_2[0]
    assert_equal "pizza", suggestion_3[0]
  end

  def test_it_can_list_lexicon
    @completion.populate("./data/dictionary_tiny_sample")
    lexicon = @completion.lexicon

    assert lexicon.include?("pizzeria")
    assert lexicon.include?("student")
  end

  def test_it_can_remove_words
    @completion.populate("./data/dictionary_tiny_sample")
    assert @completion.include?("pizza")
    assert_equal 13, @completion.count

    @completion.delete("pizza")
    assert_equal ["pizza"], @completion.deleted

    assert_equal 12, @completion.count
    refute @completion.include?("pizza")
  end

  def test_it_can_remove_deleted_words_from_lists
    words = ["pizza", "pizzeria", "piaza", "etc"]
    @completion.delete("pizza")

    words = @completion.filter_deletions(words)
    assert_equal ["pizzeria", "piaza", "etc"], words
  end

  def test_it_can_reset_deleted_words
    words = ["pizza", "pizzeria", "piaza", "etc"]
    @completion.delete("pizza")
    @completion.reset_deletions

    assert_equal [], @completion.deleted
    assert_equal words, @completion.filter_deletions(words)
  end

  def test_it_can_use_large_datasets
    @completion.default = "addresses"
    file = "./data/addresses.csv"
    header = "FULL_ADDRESS"
    @completion.populate(file, csv_header: header, trie_name: "addresses")
    assert_equal 313415, @completion.count
  end
end
