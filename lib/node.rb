class Node

  attr_accessor   :word
  attr_reader     :value,
                  :children

  def initialize(value)
    @value = value
    @word = nil
    @children = {}
  end

  def add_child(char)
    if @children.has_key?(char)
      return @children[char]
    else
      node = Node.new(char)
      @children[char] = node
      node
    end
  end

  def child(char)
    return @children
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

end
