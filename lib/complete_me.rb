require 'pry'
require 'csv'

class CompleteMe

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

  def normalize(word)
    word.downcase!
    word.tr(".", "")
  end

  def terminal_node(word, node = @root)
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

  # Takes in a portion of a word as 'snippit'
  # Returns an array of words that start with 'snippit' sorted by their weights for the given 'snippit'
  def suggest(snippit)
    node = terminal_node(snippit)
    suggestions = node.descendant_words(snippit)
    return sort_suggestions(suggestions)
  end

  def suggest_all(snippit)
    first_char = snippit[0]
    remaining_snippit = snippit.slice(1..-1)
    nodes = all_nodes_by_value(first_char)

    all_suggestions = {}
    nodes.each do |starting_node|
      eow_node = terminal_node(remaining_snippit, starting_node)
      suggestions = eow_node.descendant_words(snippit)
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
    @root.descendant_words
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

  def all_nodes_by_value(char, depth = 100)
    @root.descendant_nodes_by_value(char, depth)
  end

  def select(snippit, word)
    node = terminal_node(word)
    node.add_weight(snippit)
  end

  def delete(word)
    terminal_node(word).remove_word
  end

end
