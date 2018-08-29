require 'simplecov'
SimpleCov.start

# require 'test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'
require './lib/trie'
require './lib/node'

class TrieTest < Minitest::Test

  def setup
    # Use "CompleteMe" to setup a populated trie
    @completion = CompleteMe.new
    @completion.populate("./data/dictionary_tiny_sample")

    @trie = @completion.tries["words"]
  end

  def test_it_exists
    assert_instance_of Trie, @trie
  end

  def test_it_can_detect_if_word_is_present
    assert @trie.include?("pizza")
  end

  def test_detect_if_word_is_absent
    refute @trie.include?("4i2364876")
  end

  def test_can_insert_new_word
    refute @trie.include?("computer")
    @trie.insert("computer")
    assert @trie.include?("computer")
  end

  def test_it_can_count_words
    assert_equal 13, @trie.count
    @trie.insert("computer")
    assert_equal 14, @trie.count
  end

  def test_it_can_list_lexicon
    lexicon = @trie.lexicon
    assert lexicon.include?("pizza")
    assert_equal 13, lexicon.size
    refute lexicon.include?("computer")
  end

  def test_it_can_suggest_words
    suggestion = @trie.suggest("piz")
    assert suggestion.include?("pize")
    assert suggestion.include?("pizza")
  end

  def test_it_doesnt_suggest_word_identical_to_snippit
    suggestion = @trie.suggest("pize")
    refute suggestion.include?("pize")
  end

  def test_it_deosnt_suggest_unrelated_words
    suggestion = @trie.suggest("piz")
    refute suggestion.include?("pokemon")
  end

  def test_blank_snippet_last_node_of_snippit_is_base_node
    nodes = @trie.all_nodes_by_value('i')
    first_node = nodes[0]
    last_node = @trie.last_node_of_snippit("", first_node)
    assert_equal first_node, last_node
  end

  def test_word_is_unflagged_when_deleted
    assert @trie.include?("pokemon")
    @trie.delete("pokemon")
    refute @trie.include?("pokemon")
  end

  def test_trie_trims_unused_nodes_on_deletion
    term = @trie.last_node_of_snippit("stud")
    assert_equal 2 ,term.children.size
    @trie.delete("student")
    @trie.delete("students")
    assert @trie.include?("stud")
    assert_equal 1 ,term.children.size
  end

  def test_trie_doesnt_overtrim_on_deletion
    @trie.delete("student")
    assert @trie.include?("students")
    refute @trie.include?("student")
  end

  def test_it_can_find_all_nodes_for_specific_character
    nodes = @trie.all_nodes_by_value('z')
    assert_instance_of Node, nodes[0]
    assert_equal 2, nodes.size
    nodes = @trie.all_nodes_by_value('e')
    assert_equal 7, nodes.size
  end

  def test_absent_snippit_returns_no_suggestions
    suggestion = @trie.suggest("aaa")
    assert_equal [], suggestion
  end

  def test_can_suggest_words_with_midword_snippit
    suggestion = @trie.suggest("zz")
    assert suggestion.include?("pizza")
    assert suggestion.include?("pizzeria")
  end

  def test_can_suggest_words_with_endword_snippit
    suggestion = @trie.suggest("mon")
    assert suggestion.include?("pokemon")
  end

  def test_can_weight_words_based_on_selction
    @trie.select("piz", "pizzeria")
    suggestion = @trie.suggest("piz")
    assert_equal "pizzeria", suggestion[0]
  end

  def test_weights_are_independant
    @trie.select("piz", "pizzeria")
    @trie.select("pi", "pize")
    @trie.select("pizz", "pizza")
    suggestion_1 = @trie.suggest("piz")
    suggestion_2 = @trie.suggest("pi")
    suggestion_3 = @trie.suggest("pizz")
    assert_equal "pizzeria", suggestion_1[0]
    assert_equal "pize", suggestion_2[0]
    assert_equal "pizza", suggestion_3[0]
  end

  def test_can_suggest_addresses
    suggestion = @trie.suggest("Blvd")
    assert suggestion.include?("555 N Broadway Blvd")
  end

  def test_cand_weight_addresses_based_on_selection
    suggestion = @trie.suggest("Blvd")
    refute_equal "555 N Broadway Blvd", suggestion[0]
    @trie.select("Blvd", "555 N Broadway Blvd")
    suggestion = @trie.suggest("Blvd")
    assert_equal "555 N Broadway Blvd", suggestion[0]
  end
end
