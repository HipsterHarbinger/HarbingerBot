require 'rubygems'
require 'bundler/setup'
require 'cinch'
require 'yaml'
require 'net/http'
require_relative 'twitch_commands'
require_relative 'stream'

class Cinch::Message
  def twitch(string)
    string = string.to_s.gsub('<','&lt;').gsub('>','&gt;')
    bot.irc.send ":#{bot.config.user}!#{bot.config.user}@#{bot.config.user}.tmi.twitch.tv PRIVMSG #{channel} :#{string}"
  end
end

class Cinch::Channel
  def twitch(string)
    string = string.to_s.gsub('<','&lt;').gsub('>','&gt;')
    bot.irc.send ":#{bot.config.user}!#{bot.config.user}@#{bot.config.user}.tmi.twitch.tv PRIVMSG #{self} :#{string}"
  end
end

config = YAML.load_file('config.yml')

messages = config['channel']['messages']
message_position = 0

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = "irc.twitch.tv"
    c.channels = [config['channel']['name']]
    c.nick = config['bot_name']
    c.user = config['bot_name']
    c.password = config['password']
    c.plugins.plugins = [TwitchCommands]
  end
end

timer = Cinch::Timer.new(bot, {interval: 600}) do
  channel = bot.channel_list.find(config['channel']['name'])
  stream = Stream.new(config['channel']['name'].delete('#'))
  unless stream.nil?
    message_position += 1
    message_position = message_position % messages.length
    message = messages[message_position]
    channel.twitch(message)
  end
end

timer.start

bot.start

