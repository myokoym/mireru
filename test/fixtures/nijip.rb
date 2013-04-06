require 'cairo'

w = 400
h = 400

Cairo::ImageSurface.new(w, h) do |surface|
  context = Cairo::Context.new(surface)

  # 放射グラデーション
  pattern = Cairo::RadialPattern.new(w/3, h/3, 330, w/3, h/3, 0)
  start = 1.0
  [:white,
   :red,
   :orange,
   :yellow,
   :green,
   :aqua,
   :blue,
   :purple,
   :black].each do |c|
    pattern.add_color_stop(start -= 0.1, c)
  end
  context.set_source(pattern)

  # 背景
  #context.paint(0.1)
  
  # 文字
  context.select_font_face('Ubuntu')
  context.move_to(60, 350)
  context.font_size = 250
  context.show_text("my")
  
  surface.write_to_png("nijip.png")
end
