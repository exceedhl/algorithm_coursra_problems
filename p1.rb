a = []

File.open("IntegerArray.txt").each_line do |line|
  a << line.to_i
end

require 'pp'

def find_inversion(list)
  size = list.size

  return [list, 0] if size == 1
  if size == 2
    if list.first <= list.last
      return [list, 0]
    end
    return [list.reverse, 1]
  end

  first, c1 = find_inversion(list[0, size/2])
  last, c2 = find_inversion(list[size/2, size])

  count = 0
  sorted_array = []
  
  i = j = 0
  while i < first.size || j < last.size
    if i >= first.size 
      sorted_array.concat last.slice(j, last.size)
      break
    end
    if j >= last.size
      sorted_array.concat first.slice(i, first.size)
      break
    end
    if first[i] <= last[j]
      sorted_array << first[i]
      i += 1
    else
      sorted_array << last[j]
      count += first.size - i
      j += 1
    end
  end
  [sorted_array, count + c1 + c2]
end

pp find_inversion(a)[1]


