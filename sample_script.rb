# A sample script to do some "live testing" of all stages of the project

require_relative "lib/dom_parser.rb"

puts "Initializing DOM parser..."
parser = DOMParser.new
puts "Reading file sample.html..."
string_array = parser.read_file("sample.html")
puts
puts "Converting into tree-able array..."
attr_hash_array = parser.parser(string_array)
puts
puts "Populating tree..."
parser.tree.populate(attr_hash_array)
puts
puts "Inspecting the tree..."
p parser.tree
puts
puts "Rendering tree data..."
parser.renderer.render
puts
puts "Rendering data from node matching a search..."
matches = parser.searcher.search_by("class","foo")
parser.renderer.render_node_data(matches[0])
puts
puts "Rendering full tree as html..."
puts parser.recreate_html
puts
puts "Writing tree html back to sample_out.html..."
parser.writer.create_html_file(parser.recreate_html)
puts "Done."
