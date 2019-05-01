require 'pp'

data = [1, 3, -8, 2, -1, 10, -2, 1]

l = {}

for i in 0...data.length
  l["#{i}_#{i}"] = data[i]
end

def max(*list)
  m = list[0]
  list.each do |i|
    if !i.nil? && i > m
      m = i
    end
  end
  return m
end

pp l

for s in 1...data.length
  for i in 0...(data.length - s)
    l["#{i}_#{i+s}"] = l["#{i}_#{i+s-1}"] + data[i+s]
  end
end

pp data
pp l
