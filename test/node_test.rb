require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'
require 'pry'

class NodeTest < Minitest::Test

  def test_it_exists
    node = Node.new("a")
    assert_instance_of Node, node
  end

  def test_it_has_a_value
    node = Node.new("a")
    assert_equal "a", node.value
  end

  def test_it_can_add_children
    node_1 = Node.new("a")
    node_1.add_child("b")
    assert_equal "b", node_1.children["b"].value
  end

  def test_returns_child_if_child_already_exits
    node_1 = Node.new("a")
    b = node_1.add_child("b")
    c = node_1.add_child("b")
    assert b == c
  end

  def test_nodes_have_parents
    node_1 = Node.new("a")
    node_2 = node_1.add_child("b")
    assert_equal node_1, node_2.parent
  end
  
end
