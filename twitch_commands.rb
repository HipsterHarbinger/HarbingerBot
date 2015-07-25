require 'cinch'
require_relative 'stream'

class TwitchCommands
  include Cinch::Plugin

  match(/game$/, method: :game)
  def game(m)
    channel_name = m.channel.name.tr('#', '')
    stream = Stream.new(channel_name)
    m.twitch(stream.game)
  end

  match(/dr$/, method: :dangan_ronpa)
  def dangan_ronpa(m)
    m.twitch('Dangan Ronpa is a mix of Phoenix Wright and Battle Royale. The characters are locked in a school and forced to murder to escape.')
  end

  match(/uptime$/, method: :uptime)
  def uptime(m)
    channel_name = m.channel.name.tr('#', '')
    stream = Stream.new(channel_name)
    m.twitch(time_diff(string_to_time(stream.created_at), Time.now.utc)) unless stream.nil? 
  end

  match(/ht$/, method: :highlightThat)
  def highlightThat(m)
    channel_name = m.channel.name.tr('#', '')
    stream = Stream.new(channel_name)
    unless stream.nil?
      uptime = time_diff(string_to_time(stream.created_at), Time.now.utc)
      config = YAML.load_file('config.yml')
      File.open(config['channel']['ht_location'], 'a') { |file| file.write("#{stream.game} started at #{string_to_time(stream.created_at).getlocal('-05:00')} @ #{uptime}\n") }
    end
  end

  def string_to_time(time_string)
    Time.parse(time_string)
  end

  def time_diff(start_time, end_time)
    time_diff = (start_time - end_time).to_i.abs

    Time.at(time_diff).utc.strftime '%H:%M:%S'
  end
end
