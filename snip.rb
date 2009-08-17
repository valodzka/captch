# -*- coding: utf-8 -*-

require 'rmagick'

require 'common'

FILES.times{|t|
  img = Magick::Image.read("mono/#{t}.png").first

  delimiters = []
  direct = true

  # Ищем разделители
  img.columns.times{|j|
    pxs = img.get_pixels(j, 0, 1, img.rows)
    has_black = pxs.find{|px| px.red == 0 }
    
    if has_black && direct
      delimiters << [j]
      direct = false
    elsif !has_black && !direct
      delimiters.last << j
      direct = true
    end
  }

  if !direct
    delimiters.last << img.columns - 1
  end

  # выбрасываем явную лажу
  delimiters.reject!{|(s,e)| e - s < 2 }
  
  # Разбиваем большие части
  if delimiters.size < 6
    new_delimiters = []
    max = delimiters.max_by{|(b,e)| e - b }
    if delimiters.size == 5
      # просто ищем самою большую и делим на два
      delimiters.each{|e|
        if e == max
          half = (e.last - e.first) / 2
          new_delimiters << [e.first, e.first+half] << [e.first+half, e.last]
        else
          new_delimiters << e
        end
      }
    elsif delimiters.size == 4 && (max.last - max.first) >= 65
      # Разбиваем большую на три
      delimiters.each{|e|
        if e == max
          third = (e.last - e.first) / 3
          new_delimiters << [e.first, e.first+third] << [e.first+third, e.last-third] << [e.last-third, e.last]
        else
          new_delimiters << e
        end
      }
    elsif delimiters.size == 4
      # Разбиваем две большие
      max2 = (delimiters - [max]).max_by{|(b,e)| e - b }
      delimiters.each{|e|
        if e == max || e == max2
          half = (e.last - e.first) / 2
          new_delimiters << [e.first, e.first+half] << [e.first+half, e.last]
        else
          new_delimiters << e
        end
      }
    else
      # Как повезёт
      delimiters.map!{|(b, e)|
        if e - b > 30
          half = (e - b) / 2
          new_delimiters << [b, b+half] << [b+half, e]
        else
          new_delimiters << [b, e]
        end
      }
    end

    delimiters = new_delimiters
  end


  # Ограничиваем сверху и снизу
  delimiters.each_with_index{|(start, stop), index|
    from, to = 0, img.rows
    
    img.rows.times{|i|
      pxs = img.get_pixels(start, i, stop - start, 1)
      if pxs.find{|px| px.red == 0 }
        from = i
        break
      end
    }

    (img.rows - 1).downto(0) {|i|
      pxs = img.get_pixels(start, i, stop - start, 1)
      if pxs.find{|px| px.red == 0 }
        to = i
        break
      end
    }

    subimg = img.crop(start, from, stop - start, to - from)
    subimg.write(("sniped/%02d-%02d.png") % [t, index])
  }
}

