
require 'ruby_fann/neural_network'

require 'common'

data = RubyFann::TrainData.new(:filename => 'data.train')
fann = RubyFann::Standard.new(:num_inputs=>IMG_SIZE, :hidden_neurons=> [IMG_SIZE/2], :num_outputs=>34)

#fann.set_activation_function_hidden  :sigmoid_symmetric_stepwise
#fann.set_activation_function_output :sigmoid_symmetric_stepwise

fann.train_on_data(data, 1000, 10, 0.01)

fann.train_epoch(data)
fann.save('data3.fann')




