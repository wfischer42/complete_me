require './lib/node'

class Trie

  def initialize
    @root = Node.new(nil)
  end

  def insert(word)
    node = @root
    word.chars.each do |char|
      child = node.add_child(char)
      node = child
    end
    node.word = word
    node
  end

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

  def suggest(snippit)
    first_char = snippit[0]
    remaining_snippit = snippit.slice(1..-1)
    nodes = all_nodes_by_value(first_char)

    suggestions = nodes.inject([]) do |suggestions, node|
      eos_node = last_node_of_snippit(remaining_snippit, node)
      suggestions += eos_node.descendant_words(snippit)
    end
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

  def all_nodes_by_value(char)
    @root.descendant_nodes_by_value(char)
  end

  def delete(word)
    last_node_of_snippit(word).remove_word
  end
  
end
