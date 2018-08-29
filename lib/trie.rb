require 'pry'
require 'csv'

class Trie

  def initialize
    @root = Node.new(nil)
  end

  def insert(word)
    node = @root
    # word = normalize(word)
    word.chars.each do |char|
      child = node.add_child(char)
      node = child
    end
    node.word = word
    node
  end

  # def normalize(word)
  #   word.downcase!
  #   word.tr(".", "")
  # end

  def last_node_of_snippit(word, node = @root)
    word.chars.each do |char|
      if node.children[char] != nil
        node = node.children[char]
      else
        return Node.new(nil)
      end
    end
    return node
  end

  def count
    @root.count
  end

  def populate(dictionary)
    # TODO: Merge populate methods to distinguish between text & csv inputs
    words = dictionary.split("\n")
    words.each do |word|
      insert(word)
    end
  end

  def populate_addresses(file)
    # TODO: Handle bad file input
    CSV.foreach(file, :headers => true) do |row|
      insert(row['FULL_ADDRESS'])
    end
  end

  # def suggest_from_beginning(snippit)
  #   node = last_node_of_snippit(snippit)
  #   suggestions = node.descendant_words(snippit)
  #   return sort_suggestions(suggestions)
  # end

  def suggest(snippit)
    first_char = snippit[0]
    remaining_snippit = snippit.slice(1..-1)
    nodes = all_nodes_by_value(first_char)

    all_suggestions = {}
    nodes.each do |starting_node|
      eos_node = last_node_of_snippit(remaining_snippit, starting_node)
      suggestions = eos_node.descendant_words(snippit)
      all_suggestions.merge!(suggestions)
    end
    return sort_suggestions(all_suggestions)
  end


  def sort_suggestions(words)
    require 'pry'
    sorted = words.sort_by do |word, weight|
      weight * -1
    end.to_h
    return sorted.keys
  end

  def lexicon
    @root.descendant_words.keys
  end

  def include?(word)
    node = @root
    word.chars.each do |char|
      node = node.children[char]
      return false if node == nil
      return true if word == node.word
    end
    return false
  end

  def all_nodes_by_value(char)
    @root.descendant_nodes_by_value(char)
  end

  def select(snippit, word)
    node = last_node_of_snippit(word)
    node.add_weight(snippit)
  end

  def delete(word)
    last_node_of_snippit(word).remove_word
  end

end