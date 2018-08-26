require 'pry'
class CompleteMe

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

  def terminal_node(word)
    node = @root
    word.chars.each do |char|
      if node.children[char] != nil
        node = node.children[char]
      else
        break
      end
    end
    return node
  end

  def count
    @root.count
  end

  def populate(dictionary)
    words = dictionary.split("\n")
    words.each do |word|
      insert(word)
    end
  end

  def suggest(snippit)
    node = terminal_node(snippit)
    suggestions = node.descendant_words(snippit)
    return sort_suggestions(suggestions)
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

  def select(snippit, word)
    node = terminal_node(word)
    node.add_weight(snippit)
  end

end
