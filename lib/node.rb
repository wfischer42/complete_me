class Node

  attr_accessor   :word
  attr_reader     :value,
                  :children

  def initialize(value)
    @value = value
    @word = false
    @children = {}
  end

  def add_child(char)
    node = Node.new(char)
    @children[char] = node
  end

end
