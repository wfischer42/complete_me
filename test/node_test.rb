require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'

class NodeTest < Minitest::Test

  def test_it_exists
    node = Node.new("a")
    assert_instance_of Node, node
  end

  def test_it_has_a_value
    node = Node.new("a")
    assert_equal "a", node.value
  end

  def test_it_can_have_children
    node_1 = Node.new("a")
    node_2 = Node.new("b")
    node_1.give_child(node_2)
    expected = b:node_2
    assert_equal expected, node_1.children
  end

end
