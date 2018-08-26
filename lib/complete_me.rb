class CompleteMe

  def initialize
    @root = Node.new(nil)
  end

  def insert(word)
    #Traverse down the trie, making new nodes as needed
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
    #Call insert over each newline of the dictionary
    File.readlines(dictionary).each do |line|
      insert(line)
    end
  end

  def suggest(word)
    #Travese down the trie to the given word/prefix. Collect and return a list of the
    #closest nodes
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
