require 'simplecov'
SimpleCov.start

# require 'test/test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'
require './lib/node'

class CompleteMeTest < Minitest::Test
  extend Minitest::Spec::DSL
  # TODO: Consolidate test setup & clean up tests
  # TODO: Ensure full test coverage

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
    completion.insert("pizzeria")
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
    completion.insert("pizzeria")
    completion.insert("dog")

    lexicon = completion.lexicon
    assert lexicon.include?("pizza")
    assert lexicon.include?("pizzeria")
    assert lexicon.include?("dog")
    refute lexicon.include?("cat")
  end

  def test_it_can_suggest_words

    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pize")
    suggestion = completion.suggest("piz")

    assert suggestion.include?("pize")
    assert suggestion.include?("pizza")
  end

  def test_it_doesnt_suggest_word_identical_to_snippit
    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pize")
    suggestion = completion.suggest("pize")

    refute suggestion.include?("pize")
  end

  def test_it_deosnt_suggest_unrelated_words
    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pize")
    completion.insert("pokemon")
    suggestion = completion.suggest("piz")
    refute suggestion.include?("pokemon")
  end

  def test_blank_snippet_terminal_node_is_base_node
    completion = CompleteMe.new
    completion.insert("pizza")
    nodes = completion.all_nodes_by_value('i')
    eow_node = completion.terminal_node("", nodes[0])

    assert_equal nodes[0], eow_node
  end

  def test_word_is_unflagged_when_deleted
    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pize")
    completion.insert("pokemon")
    assert completion.include?("pokemon")
    completion.delete("pokemon")
    refute completion.include?("pokemon")
  end

  def test_trie_trims_unused_nodes_on_deletion
    completion = CompleteMe.new
    completion.insert("stud")
    completion.insert("student")
    completion.insert("students")
    completion.insert("studio")
    term = completion.terminal_node("stud")
    assert_equal 2 ,term.children.size

    completion.delete("student")
    completion.delete("students")
    assert completion.include?("stud")
    assert_equal 1 ,term.children.size

  end

  def test_trie_doesnt_overtrim_on_deletion
    completion = CompleteMe.new
    completion.insert("stud")
    completion.insert("student")
    completion.insert("students")
    completion.insert("studio")

    completion.delete("student")
    assert completion.include?("students")
    refute completion.include?("student")
  end

  def test_it_can_find_all_nodes_for_specific_character
    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pize")
    completion.insert("pokemon")

    nodes = completion.all_nodes_by_value('z')
    assert_instance_of Node, nodes[0]
    assert_equal 2, nodes.size

    nodes = completion.all_nodes_by_value('e')
    assert_equal 2, nodes.size
  end


  def test_absent_snippit_returns_no_suggestions
    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pize")
    completion.insert("pokemon")
    suggestion = completion.suggest_all("aaa")

    assert_equal [], suggestion
  end

  def test_suggests_words_with_midword_snippit
    completion = CompleteMe.new
    completion.insert("pizza")
    completion.insert("pize")
    completion.insert("pokemon")
    suggestion = completion.suggest_all("zz")

    assert_equal ['pizza'], suggestion
  end

  ########### Tests that load dictionary #############

  def test_can_populate_from_a_dictionary
    # # skip
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)

    assert_equal 235886, completion.count
    assert completion.include?("tissue")
  end

  def test_can_suggest_from_dictionary_with_endword_snippit
    # # skip
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    suggestion = completion.suggest_all("ism")
    # p suggestion
    assert suggestion.include?("capitalism")
  end

  def test_can_suggest_from_dictionary_with_midword_snippit
    # skip
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    suggestion = completion.suggest_all("mut")
    assert suggestion.include?("dismutation")
  end

  def test_can_suggest_many_words_after_population
    # skip
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)

    suggestion = completion.suggest("piz")
    expected = ["pize", "pizza", "pizzeria", "pizzicato", "pizzle"]

    assert_equal expected, suggestion
  end

  def test_can_weight_words_based_on_selction
    # skip
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)

    completion.select("piz", "pizzeria")
    suggestion = completion.suggest("piz")
    assert_equal "pizzeria", suggestion[0]

  end

  def test_weights_are_independant
    # skip
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)

    completion.select("piz", "pizzeria")
    completion.select("pi", "pillow")
    completion.select("pizz", "pizza")
    suggestion_1 = completion.suggest("piz")
    suggestion_2= completion.suggest("pi")
    suggestion_3 = completion.suggest("pizz")

    assert_equal "pizzeria", suggestion_1[0]
    assert_equal "pillow", suggestion_2[0]
    assert_equal "pizza", suggestion_3[0]
  end

  def test_it_can_find_character_nodes_from_dictionary
    # skip
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    nodes = completion.all_nodes_by_value('a', 2)
    a_node_count = nodes.count do |node|
      node.value == "a"
    end
    assert_equal nodes.size, a_node_count
    # No good way to make sure all 'a' nodes are returned without
    # making the test circular.
  end

  ########### Tests that load address list #############

  def test_it_can_read_in_addresses
    # skip
    address_completion = CompleteMe.new
    address_completion.populate_addresses("./data/addresses.csv")

    assert_equal 313415, address_completion.count
  end

  def test_it_can_suggest_addresses
    # skip
    completion = CompleteMe.new
    completion.populate_addresses("./data/addresses.csv")
    suggestion = completion.suggest("1350 N")

    assert suggestion.include?("1350 N Speer Blvd Unit 422")
  end

  def test_it_can_update_address_suggestions_from_selection
    # skip
    completion = CompleteMe.new
    completion.populate_addresses("./data/addresses.csv")
    suggestion = completion.suggest("1350 N")
    assert_equal "1350 N Elm St", suggestion[0]

    completion.select("1350 N", "1350 N Josephine St Apt 106")
    suggestion = completion.suggest("1350 N")
    assert_equal "1350 N Josephine St Apt 106", suggestion[0]
  end

  # def test_can_suggest_many_words_after_population
  #   # skip
  #   completion = CompleteMe.new
  #   dictionary = File.read("/usr/share/dict/words")
  #   completion.populate(dictionary)
  #
  #   suggestion = completion.suggest_all("piz")
  #   # expected = ["pize", "pizza", "pizzeria", "pizzicato", "pizzle"]
  #   p suggestion
  #   # assert_equal expected, suggestion
  # end
end
