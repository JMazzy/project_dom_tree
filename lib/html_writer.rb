class HTMLWriter
  def initialize
  end

  def create_html_file(string)
    file = File.new("sample_out.html", "w")

    file.write(string)

    file.close
  end
end
