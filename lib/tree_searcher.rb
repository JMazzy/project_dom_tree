class TreeSearcher
  def initialize(tree=nil)
    @tree = tree
  end

  def update_tree(tree)
    @tree = tree
  end

  # returns true if the search data matches the node data
  def match_node?(key_type, search_term, data)
    if key_type == 'class' && data['class']
      data['class'].each do |cls|
        if cls == search_term
          return true
        end
      end
    elsif data[key_type] == search_term
      return true
    end
    false
  end

  def search_by(key_type, search_term)
    search(@tree.root, key_type, search_term,false)
  end

  def search_descendents(node,key_type,search_term)
    search(node,key_type,search_term,false)
  end

  def search_ancestors(node,key_type,search_term)
    search(node,key_type,search_term,true)
  end

  private

  def search(node, key_type, search_term, search_parents)
    matches = []
    key_type = key_type.to_s
    current_node = node

    # Create the stack
    stack = Stack.new
    stack.push(current_node)

    loop do
      current_node = stack.pop
      data = current_node.data
      children = current_node.children
      parent = current_node.parent

      if match_node?(key_type,search_term,data)
        matches << current_node
      end

      if !search_parents && !children.empty?
        children.reverse_each do |child|
          stack.push(child)
        end
      elsif !!parent && search_parents
        stack.push(parent)
      else
        stack.empty? ? break : next
      end
    end
    matches
  end
end
