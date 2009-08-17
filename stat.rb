
samples = IO.readlines('samples.txt').map{|line| line[0...6] }.reject{|line| line.size != 6 }

stat = Hash.new(0)
samples.each{|s|
  s.each_byte{|b|
    stat[b.chr] += 1
  }
}

set = ('0'..'9').to_a + ('a'..'z').to_a
set.each{|ch|
  puts "#{ch} -> #{stat[ch]}"
}

p set.size


