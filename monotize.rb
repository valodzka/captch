
require 'rmagick'

require 'common'

D = 50000

FILES.times{|t|
  img = Magick::Image.read("samples/#{t}.png").first
  view = img.view(0, 0, img.columns, img.rows)

  img.rows.times{|i|
    img.columns.times{|j|
      px = view[i][j]
      px.red = px.green = px.blue = (px.red < D && px.red == px.blue && px.blue == px.green ? 0 : 0xffff)
    }
  }

  view.sync
  img.write("mono/#{t}.png")
}

