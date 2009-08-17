
require 'common'

fann = RubyFann::Standard.new(:filename => 'data.fann')
expected = %w{ h f 8 g 8 9 d t 8 r h v d t 9 m 8 g j 3 s j f e d e 6 g e e 5 l w v r 7  f q u g s j t p 1 w 1 d q s g f y n 5 b i 2 e k}
all, win = 0, 0

Dir['test-sniped/*.png'].each_with_index{|file, i|
  o = fann.run(img_to_data(file))

  index = o.index(o.max)

  got = index_to_ch(index)
  exp = expected[i]
  puts "For #{file} got #{got}, expected #{exp} -> #{got == exp ? 'win' : 'fail'}"
  all += 1
  win += 1 if got == exp
}

puts "#{win} from #{all}, #{win/all.to_f * 100}%"

