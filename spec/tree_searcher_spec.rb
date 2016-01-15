require 'dom_parser'

describe "TreeSearcher" do

  let(:tree_searcher) { TreeSearcher.new }
  let(:data) { {"class" => ["foo", "bar"] } }
  let(:tree) { DOMTree.new.populate( [
    {:type => :start_tag, :tag_name => "div", "id" => "awesome", "class" => ["foo", "bar"]},
    {:type => :text, :content => "Hello RSpec!"},
    {:type => :end_tag, :tag_name => "div"} ] ) }

  before do
    tree_searcher.update_tree(tree)
  end

  describe "match_node" do
    it "returns true if the search term matches" do
      expect(tree_searcher.match_node?("class", "foo", data)).to eq(true)
    end

    it "returns false if the search term doesn't match" do
      expect(tree_searcher.match_node?("class", "boo", data)).to eq(false)
    end
  end

  describe "search_by" do
    it "returns an array of nodes" do
      puts tree
      results = tree_searcher.search_by("class", "foo")
      results.each do |result|
        expect(result).to be_a(Node)
      end
    end

    it "returns an array of nodes - take 2" do
      results = tree_searcher.search_by("id", "awesome")
      results.each do |result|
        expect(result).to be_a(Node)
      end
    end

    it "returns an empty array if no matches" do
      results = tree_searcher.search_by("id", "bar")
      expect(results).to be_a(Array)
      expect(results).to be_empty
    end
  end

  describe "search_descendents" do
    it "returns an array of nodes" do
      node = tree.root
      expect(node).to be_a(Node)
      results = tree_searcher.search_descendents(node, "class", "foo")
      results.each do |result|
        expect(result).to be_a(Node)
      end
    end

    it "returns an empty array if no matches" do
      node = tree.root
      expect(node).to be_a(Node)
      results = tree_searcher.search_descendents(node,"id", "bar")
      expect(results).to be_a(Array)
      expect(results).to be_empty
    end
  end

  describe "search_ancestors" do
    it "returns an array of nodes" do
      node = tree.root.children[0].children[0]
      expect(node).to be_a(Node)
      results = tree_searcher.search_ancestors(node, "class", "foo")
      results.each do |result|
        expect(result).to be_a(Node)
      end
    end

    it "returns an empty array if no matches" do
      node = tree.root.children[0].children[0]
      expect(node).to be_a(Node)
      results = tree_searcher.search_ancestors(node,"id", "bar")
      expect(results).to be_a(Array)
      expect(results).to be_empty
    end

    it "returns an empty array if on the root node" do
      node = tree.root
      expect(node).to be_a(Node)
      results = tree_searcher.search_ancestors(node,"class", "bar")
      expect(results).to be_a(Array)
      expect(results).to be_empty
    end
  end
end
