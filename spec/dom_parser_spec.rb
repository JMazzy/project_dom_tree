require 'dom_parser'

describe "DOMParser" do
  let(:dom_parser){ DOMParser.new }

  let(:p_test){"<p class='foo bar' id='baz' name='fozzie'>"}
  let(:url_test){"<img src='http://www.example.com' title='funny things'>"}

  let(:p_hash){{:type=>:start_tag, :tag_name=>"p", "class"=>["foo", "bar"], "id"=>"baz", "name"=>"fozzie"}}
  let(:url_hash){{:type=>:start_tag, :tag_name=>"img", "src"=>"http://www.example.com", "title"=>"funny things"}}

  let(:opening) {"<div>"}
  let(:closing) {"</div>"}


  describe "#tag_parser" do
    it "parses tags into a hash, with attr_name (key) attr_value (value)" do
      expect(dom_parser.tag_parser(p_test)).to eq(p_hash)
    end

    it "parses tags with urls" do
      expect(dom_parser.tag_parser(url_test)).to eq(url_hash)
    end

  end

  describe "#build_start_tag" do

    it "returns html from hash (paragraph test)" do
      expect(dom_parser.build_start_tag(p_hash)).to eq(p_test)
    end

    it "returns html with urls from hash" do
      expect(dom_parser.build_start_tag(url_hash)).to eq(url_test)
    end

  end

  describe "#build_class_list" do

    it "returns a class list from an array of class names" do
      expect(dom_parser.build_class_list(["foo","bar"])).to eq("class='foo bar' ")
    end

  end


  describe "is_tag?" do
    it "returns true if it is an (opening tag)" do
      expect(dom_parser.is_tag?(opening)).to eq(true)
    end

    it "returns false if it is not an opening tag" do
      expect(dom_parser.is_tag?(closing)).to eq(false)
    end

    it "returns false if not a tag at all" do
      expect(dom_parser.is_tag?("text")).to eq(false)
    end
  end


  describe "is_closing_tag" do
    it "false if not a closing tag" do
      expect(dom_parser.is_end_tag?(opening)).to eq(false)
    end

    it "true if is a closing tag" do
      expect(dom_parser.is_end_tag?(closing)).to eq(true)
    end

    it "returns false if not a tag at all" do
      expect(dom_parser.is_end_tag?("text")).to eq(false)
    end
  end


end
