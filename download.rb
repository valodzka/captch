
require 'open-uri'

require 'common'

FILES.times { |t|
  File.open("samples/#{t}.png", 'w'){|f|
    f.write open('http://habrahabr.ru/core/captcha/').read
  }
}
