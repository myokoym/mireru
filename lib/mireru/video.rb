require "clutter-gtk"
require "clutter-gst"
require "mireru/widget"

module Mireru
  class Video
    class << self
      def create(file)
        clutter = ClutterGtk::Embed.new
        stage = clutter.stage
        stage.background_color = Clutter::Color.new(:black)
        video_texture = ClutterGst::VideoTexture.new
        stage.add_child(video_texture)
        video_texture.signal_connect("eos") do |_video_texture|
          _video_texture.progress = 0.0
          _video_texture.playing = true
        end
        video_texture.filename = file
        video_texture.playing = true
        clutter.signal_connect("destroy") do
          video_texture.playing = false
        end
        clutter
      end
    end
  end
end
