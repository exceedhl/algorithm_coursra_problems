a = [1, 3, 4, 5, 7, 8]
b = [4, 7, 8, 9]

i = j = 0

r = []
while i < a.length && j < b.length
  if a[i] == b[j]
    r << a[i]
    i += 1
    j += 1
  elsif a[i] < b[j]
    i += 1
  else
    j += 1
  end
end

require 'pp'
pp r
