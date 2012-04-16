require 'pp'

a = []

File.open("QuickSort.txt").each_line do |line|
  a << line.to_i
end

@debug = true

def qs(arr, s, e)
  # pp "before: "
  size = e - s + 1
  # pp arr.slice(s, size)
  return 0 if size <= 1
  if size == 2
    if arr[e] < arr[s]
      arr[s], arr[e] = arr[e], arr[s]
    end
    return 1
  end

  i = j = s + 1
  pivot = arr[s]
  while j <= e
    if arr[j] > pivot
      j += 1
    else
      if j > i
        arr[i], arr[j] = arr[j], arr[i]
      end
      i += 1
      j += 1
    end
  end
  arr[s], arr[i-1] = arr[i-1], arr[s]
  # pp "after"
  # pp arr.slice(s, size)
  return size - 1 + qs(arr, s, i - 2) + qs(arr, i, e)
end

def qs2(arr, s, e)
  # pp "before: "
  size = e - s + 1
  # pp arr.slice(s, size)
  return 0 if size <= 1
  if size == 2
    if arr[e] < arr[s]
      arr[s], arr[e] = arr[e], arr[s]
    end
    return 1
  end

  i = j = s + 1
  arr[s], arr[e] = arr[e], arr[s]
  # pp 'after swap'
  # pp arr.slice(s, size)
  pivot = arr[s]
  while j <= e
    if arr[j] > pivot
      j += 1
    else
      if j > i
        arr[i], arr[j] = arr[j], arr[i]
      end
      i += 1
      j += 1
    end
  end
  arr[s], arr[i-1] = arr[i-1], arr[s]
  # pp "after"
  # pp arr.slice(s, size)
  return size - 1 + qs2(arr, s, i - 2) + qs2(arr, i, e)
end

def qs3(arr, s, e)
  pp "before: " if @debug
  size = e - s + 1
  pp arr.slice(s, size) if @debug
  return 0 if size <= 1
  if size == 2
    if arr[e] < arr[s]
      arr[s], arr[e] = arr[e], arr[s]
    end
    return 1
  end

  i = j = s + 1

  first = s
  final = e
  median = (e-s)/2 + s
  pp "first: #{first - s}, median: #{median - s}, final: #{final - s}" if @debug
  p = pick_max(arr, first, final, median)
  arr[s], arr[p] = arr[p], arr[s]
  pp 'after swap' if @debug
  pp "pivot position: #{p - s}" if @debug
  pp arr.slice(s, size) if @debug
  pivot = arr[s]
  while j <= e
    if arr[j] > pivot
      j += 1
    else
      if j > i
        arr[i], arr[j] = arr[j], arr[i]
      end
      i += 1
      j += 1
    end
  end
  arr[s], arr[i-1] = arr[i-1], arr[s]
  pp "after" if @debug
  pp arr.slice(s, size) if @debug
  return size - 1 + qs3(arr, s, i - 2) + qs3(arr, i, e)
end

def pick_max(arr, first, final, median)
  if arr[first] > arr[final]
    smaller = final
    bigger = first
  else
    smaller = first
    bigger = final
  end
  return smaller if arr[median] <= arr[smaller]
  return median if arr[median] < arr[bigger]
  bigger
end

@debug = false
b = [11, 4, 3, 2, 5, 9, 10]
pp qs3(a, 0, a.size - 1)
pp b
