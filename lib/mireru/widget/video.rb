# Copyright (C) 2013-2014 Masafumi Yokoyama <myokoym@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

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
