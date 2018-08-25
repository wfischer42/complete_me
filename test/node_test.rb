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

end
