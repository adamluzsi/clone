class Array
  def index_of(target_element)
    array = self
    hash = Hash[array.map.with_index.to_a]
    return hash[target_element]
  end
  def pinch n=1
    return self[0..(self.count-2)]
  end
  def contains?(oth_array)#anothere array
    (oth_array & self) == oth_array
    #(oth_array - self).size == 0
  end
  def safe_transpose
    result = []
    max_size = self.max { |a,b| a.size <=> b.size }.size
    max_size.times do |i|
      result[i] = Array.new(self.first.size)
      self.each_with_index { |r,j| result[i][j] = r[i] }
    end
    result
  end

  alias :contain? :contains?
end