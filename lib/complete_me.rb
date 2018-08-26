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

  def count
    count = @root.count
  end

  def populate(dictionary)
    words = dictionary.split("\n")
    words.each do |word|
      insert(word)
    end
  end

  def suggest(word)
    node = @root
    word.chars.each do |char|
      if node.children[char] != nil
        node = node.children[char]
      else
        break
      end
    end
    return node.decendant_words
  end

  def lexicon
    @root.decendant_words
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

end
