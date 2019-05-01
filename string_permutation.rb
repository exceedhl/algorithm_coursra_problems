ss = "abcde"

num_perm = 1
for i in 1..ss.length
  num_perm *= i
end
puts num_perm

def string_perm(s)
  return [s] if s.length == 1
  perms = []
  string_perm(s[1..s.length]).each do |ss|
    perms << "#{s[0..0]}#{ss}"
    for i in 1..ss.length
      perms << "#{ss[0...i]}#{s[0..0]}#{ss[i...ss.length]}"
    end
  end
  return perms
end

perms = string_perm(ss)
puts perms
puts perms.size
