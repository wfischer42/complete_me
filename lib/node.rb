class Node

  attr_accessor   :word
  attr_reader     :value,
                  :children

  def initialize(value)
    @value = value
    @word = false
    @children = {}
  end

end
