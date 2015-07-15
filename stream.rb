require 'twitch'

class Stream

  def initialize(channel_name)
    @stream = Twitch.new.stream(channel_name)[:body]['stream']
  end

  def nil?
    @stream.nil?
  end

  def game
    @stream['game']
  end

  def viewers
    @stream['viewers']
  end

  def created_at
    @stream['created_at']
  end

  def video_height
    @stream['video_height']
  end

  def average_fps
    @stream['average_fps']
  end

  def links
    @stream['_links']
  end

  def preview
    @stream['preview']
  end

end
