class Stack
  def initialize
    @data = []
  end

  def push(input)
    @data[last_index + 1] = input
  end

  def pop
    return if empty?
    last_value = @data[last_index]
    new_array = Array.new(last_index)
    last_index.times do |index|
      new_array[index] = @data[index]
    end
    @data = new_array
    last_value
  end

  def empty?
    @data.size == 0
  end

  private

  def last_index
    @data.length - 1
  end
end
