
#children in an array
Node = Struct.new(:data, :children, :parent, :depth)

class DOMTree

  attr_reader :root

  # List of node types which cause tree builder to go down one level
  NODE_DOWN = [:start_tag, :text]

  def initialize
    @root = nil
    @max_depth = 0
    @total_nodes = 0
  end

  # Populates the tree given an array of tag hashes
  def populate(array)
    @root = Node.new({type: :document}, [], nil, 0)
    @total_nodes += 1
    @max_depth = 0
    current_node = @root
    current_depth = 0
    array.each do |hash|
      # opening tag - create new node
      if NODE_DOWN.include? hash[:type]
        #if <> depth += 1
        new_node = Node.new(hash, [], current_node, current_node.depth + 1)
        current_node.children << new_node
        current_node = new_node
        current_depth += 1
        @total_nodes += 1
      else #hash[:type] == "close"
        #if </> depth -= 1
        new_node = Node.new(hash, [], current_node, current_node.depth)
        current_node.children << new_node
        current_node = current_node.parent
        current_depth -= 1
        @total_nodes += 1
      end

      if current_depth > @max_depth
        @max_depth = current_depth
      end

      if hash[:type] == :text && current_node.children.empty?
        current_depth -= 1
        current_node = current_node.parent
      end
    end
    self
  end

  def inspect
    "Your tree has #{@total_nodes} nodes and a maximum depth of #{@max_depth}."
  end
end
