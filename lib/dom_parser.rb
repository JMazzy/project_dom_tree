require_relative "./dom_tree.rb"
require_relative "./html_reader.rb"
require_relative "./html_writer.rb"
require_relative "./stack.rb"
require_relative "./node_renderer.rb"
require_relative "./tree_searcher.rb"

class DOMParser

  attr_reader :reader, :writer, :tree, :renderer

  ATTR_REGEX = /(\w+)\s?=\s?'([\S]*[\w\s]*)'/
  END_TAG_REGEX = /<\/\s?([^<>\/]*)\s?>/
  TAG_NAME_REGEX = /<\s?(\w+)\s?/

  # Initializes and creates helper objects
  def initialize
    @reader = HTMLReader.new
    @writer = HTMLWriter.new
    @tree = DOMTree.new
    @renderer = NodeRenderer.new(@tree)
  end

  # Reads and converts given file into an array of html hashes
  def read_file(file_name)
    @reader.file = file_name
    @reader.convert_file
  end

  # Parses array of html tags and content
  # returns mapped array of hashes
  def parser(array)
    #identifies array element
    #runs correct parser
    # hash[type]open,close,content
    # maps to and returns array of parsed, tree-able hashes
    array.map do |piece|
      if is_tag?(piece)
        tag_parser(piece)
      elsif is_end_tag?(piece)
        end_tag_parser(piece)
      else
        content_parser(piece)
      end
    end
  end

  # Parses OPENING TAG and returns a hash of data
  def tag_parser(string)
    attr_hash = {}

    attr_hash[:type] = :start_tag

    attr_hash[:tag_name] = string.match(TAG_NAME_REGEX)[1]

    attribute_match_data = string.scan(ATTR_REGEX)
    attribute_match_data.each do |match|
      key = match[0]
      if key == "class"
        attr_hash[key] = match[1].split(" ")
      else
        attr_hash[key] = match[1]
      end
    end
    attr_hash
  end

  # Parses END TAG and returns a hash of data
  def end_tag_parser(string)
    end_tag_hash = {}
    end_tag_hash[:type] = :end_tag
    end_tag_hash[:tag_name] = string.match( END_TAG_REGEX )[1]
    end_tag_hash
  end

  # Parses TEXT content and returns a hash of data
  def content_parser(string)
    #creates content hash
    content_hash = {}

    # Type is plain text
    content_hash[:type] = :text

    # Content is the string itself
    content_hash[:content] = string

    # Return hash
    content_hash
  end

  # Creates a tree from a given file
  def create_tree
    #TODO: prompt for file name... implement if time
    @reader.file = "sample.html"
    @reader.convert_file
    @tree.populate(parser(@reader.html))
  end

  # Converts the tree into an html_string; returns the string
  def recreate_html
    html_string = ""
    stack = Stack.new
    stack.push(@tree.root)

    loop do
      current_node = stack.pop
      data = current_node.data

      html_string << data_to_html(data,current_node.depth)

      if !current_node.children.empty?
        current_node.children.reverse_each do |child|
          stack.push(child)
        end
      else
        stack.empty? ? break : next
      end
    end
    html_string.strip!
  end

  # Converts data hash into an html string; returns the string
  def data_to_html(data,depth)
    html_string = ""
    if data[:type] == :document
      # "< !DOCTYPE html >"
    else
      html_string << "\n"
      html_string << "  "*(depth-1)
      if data[:type] == :start_tag
        html_string << build_start_tag(data)
      elsif data[:type] == :end_tag
        html_string << "</#{data[:tag_name]}>"
      else
        html_string << "#{data[:content]}"
      end
    end
    html_string
  end

  # Returns an html start tag given its data hash
  def build_start_tag(data)
    start_tag = "<"
    data.each do |key,value|
      if key == :tag_name
        start_tag << "#{data[:tag_name]} "
      elsif key == "class"
        start_tag << build_class_list(data["class"])
      elsif key != :type
        start_tag << "#{key.to_s}='#{value}' "
      end
    end
    start_tag.strip!
    start_tag << ">"
  end

  # Returns an HTML class attribute with class lists
  def build_class_list(classes)
    class_list = "class='"
    classes.each do |cls|
      class_list << "#{cls} "
    end
    class_list.strip!
    class_list << "' "
    class_list
  end

  # Checks to see if a string is an opening tag
  def is_tag?(string)
    !!string.match(/<\s?[^<>\/]*\s?>/)
  end

  # Checks to see if a string is an end/closing tag
  def is_end_tag?(string)
    !!string.match(/<\/\s?[^<>\/]*\s?>/)
  end

end
