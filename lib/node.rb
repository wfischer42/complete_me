class Node

  attr_accessor   :word,
                  :weights
  attr_reader     :value,
                  :children,
                  :parent

  def initialize(value, parent = nil)
    @value = value
    @word = nil
    @children = {}
    @weights = Hash.new(0)
    @parent = parent
  end

  def add_child(char)
    if @children.has_key?(char)
      return @children[char]
    else
      node = Node.new(char,self)
      @children[char] = node
      return node
    end
  end


  def count
    node_count = 0
    children.each do |char, child|
      node_count += child.count
    end
    if @word != nil
      node_count += 1
    end
    return node_count
  end

  # Called -on- the last node of the 'snippit'
  # Takes in the snippit
  # Returns a hash of all words that descend from that node and their respective weights for the snippit
  def descendant_words(snippit = "")
    words = {}
    if @word != nil && @word != snippit
      words[@word] = @weights[snippit]
    end
    children.each do |char, child|
      if child.word != nil
        words[child.word] = child.weights[snippit]
      end
      d_words = child.descendant_words(snippit)
      words.merge!(d_words)
    end
    return words
  end

  def add_weight(snippit)
      @weights[snippit] += 1
  end

  def remove_word
    @word = nil
    @weights = Hash.new(0)
    trim
  end

  def trim
    if @children.size == 0 && @word == nil
      @parent.children.delete(@value)
      @parent.trim
      #TODO garbage collection?
    end
  end

  def descendant_nodes_by_value(char, depth)
    nodes = []
    if depth > 0
      @children.each do |child_char, child_node|
        if child_char == char
          nodes << child_node
        end
        nodes += child_node.descendant_nodes_by_value(char, depth - 1)
      end
    end
    return nodes
  end
end
