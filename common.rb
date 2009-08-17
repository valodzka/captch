
require 'ruby_fann/neural_network'
require 'rmagick'

FILES = 100
CHARS = 6
IMG_SIZE = 22*24

def img_to_data(path)
  img = Magick::Image.read(path).first
  pixels = img.get_pixels(0, 0, img.columns, img.rows)
  data = pixels.map{|px| px.red == 0 ? 1.0 : 0.0 }
  if data.size < IMG_SIZE
    add = IMG_SIZE - data.size
    data += ([0.0] * add)
  elsif data.size > IMG_SIZE
    data = data[0...IMG_SIZE]
  end

  data
end

OUTPUTS = (('0'..'9').to_a + ('a'..'z').to_a) - ['0', 'o']

def ch_to_index(ch)
  OUTPUTS.index ch
end

def index_to_ch(index)
  OUTPUTS[index]
end
