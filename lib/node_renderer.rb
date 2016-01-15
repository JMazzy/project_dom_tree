class NodeRenderer
  def initialize(tree)
    @tree = tree
    @node_type_counts = {}
    @total_nodes = 0
    @default_depth = 0
  end

  def render(node=nil)
    # Set current node based on input
    node.nil? ? current_node = @tree.root : current_node = node

    render_node_data(current_node)

    # Create the stack
    stack = Stack.new
    stack.push(current_node)

    @total_nodes = 1

    @default_depth = current_node.depth

    clear_node_type_counts

    loop do
      current_node = stack.pop
      data = current_node.data

      add_node_type_count(data)

      render_subtree_structure(data,current_node.depth)

      if !current_node.children.empty?
        current_node.children.reverse_each do |child|
          stack.push(child)
          @total_nodes += 1
        end
      else
        stack.empty? ? break : next
      end
    end
    puts
    render_subtree_data
  end

  def render_node_data(node)
    puts "Starting from node:"
    data = node.data
    data.each do |key,value|
      puts "#{key.to_s.capitalize}: #{value}"
    end
    puts "Depth: #{node.depth}"
    puts
  end

  def clear_node_type_counts
    @node_type_counts = {}
  end

  def find_node_name(data)
    if data[:type] == :text
      "text"
    elsif data[:type] == :document
      "document"
    else
      "#{data[:type]} #{data[:tag_name]}"
    end
  end

  def add_node_type_count(data)
    node_name = find_node_name(data)
    if @node_type_counts.keys.include? node_name
      @node_type_counts[node_name] += 1
    else
      @node_type_counts[node_name] = 1
    end
  end

  def render_subtree_structure(data,depth)
    print "  "*(depth-@default_depth)
    puts "#{data[:type]} #{data[:tag_name]}"
  end

  def render_subtree_data
    puts "Total nodes: #{@total_nodes}"
    puts "Node counts:"
    @node_type_counts.each do |type,num|
      puts "#{num} #{type}"
    end
  end
end
