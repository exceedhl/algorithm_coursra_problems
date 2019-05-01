A = [3, 2, 7, 1, 5, 4]
SUM = 8

require 'pp'
pp A

s = 0
e = s

sum = A[s]
found = false

while e < A.length && s <= e
  puts "#{s} .. #{e}, #{sum}"
  if sum == SUM
    found = true
    break
  elsif sum < SUM
    e += 1
    sum += A[e] if e < A.length
  else
    sum -= A[s]
    s += 1
  end
end

pp found
