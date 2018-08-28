require 'simplecov'
SimpleCov.start

# require 'test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'
require './lib/node'

class CompleteMeTest < Minitest::Test

  def setup
    @completion = CompleteMe.new
    dictionary = File.read('./data/dictionary_tiny_sample')
    @completion.populate(dictionary)
  end

  def test_it_exists
    assert_instance_of CompleteMe, @completion
  end

  def test_it_can_detect_if_word_is_present
    assert @completion.include?("pizza")
  end

  def test_detect_if_word_is_absent
    refute @completion.include?("4i2364876")
  end

  def test_can_insert_new_word
    refute @completion.include?("computer")
    @completion.insert("computer")
    assert @completion.include?("computer")
  end

  def test_it_can_count_words
    assert_equal 13, @completion.count
    @completion.insert("computer")
    assert_equal 14, @completion.count
  end

  def test_it_can_list_lexicon
    lexicon = @completion.lexicon
    assert lexicon.include?("pizza")
    assert_equal 13, lexicon.size
    refute lexicon.include?("computer")
  end

  def test_it_can_suggest_words
    suggestion = @completion.suggest("piz")
    assert suggestion.include?("pize")
    assert suggestion.include?("pizza")
  end

  def test_it_doesnt_suggest_word_identical_to_snippit
    suggestion = @completion.suggest("pize")
    refute suggestion.include?("pize")
  end

  def test_it_deosnt_suggest_unrelated_words
    suggestion = @completion.suggest("piz")
    refute suggestion.include?("pokemon")
  end

  def test_blank_snippet_terminal_node_is_base_node
    nodes = @completion.all_nodes_by_value('i')
    first_node = nodes[0]
    last_node = @completion.terminal_node("", first_node)
    assert_equal first_node, last_node
  end

  def test_word_is_unflagged_when_deleted
    assert @completion.include?("pokemon")
    @completion.delete("pokemon")
    refute @completion.include?("pokemon")
  end

  def test_trie_trims_unused_nodes_on_deletion
    term = @completion.terminal_node("stud")
    assert_equal 2 ,term.children.size
    @completion.delete("student")
    @completion.delete("students")
    assert @completion.include?("stud")
    assert_equal 1 ,term.children.size
  end

  def test_trie_doesnt_overtrim_on_deletion
    @completion.delete("student")
    assert @completion.include?("students")
    refute @completion.include?("student")
  end

  def test_it_can_find_all_nodes_for_specific_character
    nodes = @completion.all_nodes_by_value('z')
    assert_instance_of Node, nodes[0]
    assert_equal 2, nodes.size
    nodes = @completion.all_nodes_by_value('e')
    assert_equal 7, nodes.size
  end

  def test_absent_snippit_returns_no_suggestions
    suggestion = @completion.suggest("aaa")
    assert_equal [], suggestion
  end

  def test_can_suggest_words_with_midword_snippit
    suggestion = @completion.suggest("zz")
    assert suggestion.include?("pizza")
    assert suggestion.include?("pizzeria")
  end

  def test_can_suggest_words_with_endword_snippit
    suggestion = @completion.suggest("mon")
    assert suggestion.include?("pokemon")
  end

  def test_can_weight_words_based_on_selction
    @completion.select("piz", "pizzeria")
    suggestion = @completion.suggest("piz")
    assert_equal "pizzeria", suggestion[0]
  end

  def test_weights_are_independant
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

  def test_can_suggest_addresses
    suggestion = @completion.suggest("Blvd")
    assert suggestion.include?("555 N Broadway Blvd")
  end

  def test_cand_weight_addresses_based_on_selection
    suggestion = @completion.suggest("Blvd")
    refute_equal "555 N Broadway Blvd", suggestion[0]
    @completion.select("Blvd", "555 N Broadway Blvd")
    suggestion = @completion.suggest("Blvd")
    assert_equal "555 N Broadway Blvd", suggestion[0]
  end

  ########### Tests that load dictionary #############

  def test_can_populate_from_full_dictionary_and_suggest_words
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    assert_equal 235886, completion.count

    suggestion = completion.suggest("piz")
    assert suggestion.include?("pizza")
    assert suggestion.include?("papize")
    assert suggestion.include?("epizoic")
  end

  ########### Tests that load address list #############

  def test_can_populate_from_address_list_and_suggest_adresses
    address_completion = CompleteMe.new
    address_completion.populate_addresses("./data/addresses.csv")
    assert_equal 313415, address_completion.count

    suggestion = address_completion.suggest("1350 N")
    assert suggestion.include?("1350 N Speer Blvd Unit 422")
  end

end
