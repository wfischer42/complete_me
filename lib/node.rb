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

  def descendant_words(snippit = "")
    words = {}
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

end
