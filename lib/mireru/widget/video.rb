require "clutter-gtk"
require "clutter-gst"

module Mireru
  module Widget
    class Video < ClutterGtk::Embed
      def initialize(file)
        super()
        stage.background_color = Clutter::Color.new(:black)
        @video_texture = ClutterGst::VideoTexture.new
        stage.add_child(@video_texture)
        @video_texture.signal_connect("eos") do |_video_texture|
          _video_texture.progress = 0.0
          _video_texture.playing = true
        end
        @video_texture.filename = file
        @video_texture.playing = true
        signal_connect("destroy") do
          next if @video_texture.destroyed?
          @video_texture.playing = false
        end

        @video_texture.signal_connect_after("size-change") do |texture, base_width, base_height|
          stage_width, stage_height = stage.size
          frame_width, frame_height = texture.size

          new_height = (frame_height * stage_width) / frame_width
          if new_height <= stage_height
            new_width = stage_width
            new_x = 0
            new_y = (stage_height - new_height) / 2
          else
            new_width = (frame_width * stage_height) / frame_height
            new_height = stage_height
            new_x = (stage_width - new_width) / 2
            new_y = 0
          end
          texture.set_position(new_x, new_y)
          texture.set_size(new_width, new_height)
        end
      end

      def pause_or_play
        state = @video_texture.playing?
        @video_texture.playing = state ? false : true
      end
    end
  end
end
