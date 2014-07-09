require "clutter-gtk"
require "clutter-gst"

module Mireru
  module Widget
    class Video < ClutterGtk::Embed
      class << self
        def create(file)
          new(file)
        end
      end

      def initialize(file)
        super()
        stage.background_color = Clutter::Color.new(:black)
        video_texture = ClutterGst::VideoTexture.new
        stage.add_child(video_texture)
        video_texture.signal_connect("eos") do |_video_texture|
          _video_texture.progress = 0.0
          _video_texture.playing = true
        end
        video_texture.filename = file
        video_texture.playing = true
        define_events(stage, video_texture)
        signal_connect("destroy") do
          next if video_texture.destroyed?
          video_texture.playing = false
        end
      end

      private
      def define_events(stage, video_texture)
        stage.signal_connect("event") do |_stage, event|
          handled = false

          case event.type
          when Clutter::EventType::KEY_PRESS
            animation = nil
            case event.key_symbol
            when Clutter::Keys::KEY_space
              state = video_texture.playing?
              video_texture.playing = state ? false : true
            end
            handled = true
          end

          handled
        end
      end
    end
  end
end
