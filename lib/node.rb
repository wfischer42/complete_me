class Node

  attr_accessor   :word
  attr_reader     :value,
                  :children,
                  :parent

  def initialize(value, parent = nil)
    @value = value
    @word = nil
    @children = {}
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
    child_nodes = children.values
    words = child_nodes.inject([]) do |words, child|
      # require 'pry'; binding.pry
      words += child.descendant_words(snippit)
    end
    if @word != nil && @word != snippit
      words << @word
    end
    return words
  end
  #
  # def add_weight(snippit)
  #     @weights[snippit] += 1
  # end

  def remove_word
    @word = nil
    trim
  end

  def trim
    if @children.size == 0 && @word == nil
      @parent.children.delete(@value)
      @parent.trim
    end
  end

  def descendant_nodes_by_value(char)
    nodes = []
    @children.each do |child_char, child_node|
      if child_char == char
        nodes << child_node
      end
      nodes += child_node.descendant_nodes_by_value(char)
    end
    return nodes
  end
end
