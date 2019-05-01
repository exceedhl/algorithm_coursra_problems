require 'pp'

def swap_array(a, s, e)
  while s < e
    a[s], a[e] = a[e], a[s]
    s += 1
    e -= 1
  end
end

a = [1, 2, 3]
swap_array(a, 0, a.length - 1)

pp a


def rota_array(a, pos)
  swap_array(a, 0, pos -1)
  swap_array(a, pos, a.length - 1)
  swap_array(a, 0, a.length - 1)
end


a = [1, 2, 3, 4, 5, 6]
rota_array(a, 3)
pp a
