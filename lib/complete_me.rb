class CompleteMe

  def insert(word)
    #Traverse down the trie, making new nodes as needed
  end

  def count

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

end
