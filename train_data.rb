# -*- coding: utf-8 -*-

require 'rmagick'
require 'ruby_fann/neural_network'

require 'common'

inputs = []
outputs = []
samples = IO.readlines('samples.txt').map{|line| line[0...6] }.reject{|line| line.size != 6 }
outputs_set =  (('0'..'9').to_a + ('a'..'z').to_a) - ['0', 'o']
output_template = [0.0] * outputs_set.size


FILES.times{|t|
  next if t == 67 # неудачный пример
  CHARS.times{|c|
    inputs << img_to_data('sniped/'+("%02d-%02d.png" % [t,c]))
    out = output_template.clone
    out[outputs_set.index(samples[t][c].chr)] = 1.0
 outputs << out
  }
}

data = RubyFann::TrainData.new(:inputs => inputs, :desired_outputs => outputs)
data.save('data.train')







