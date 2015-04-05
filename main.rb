require 'rubygems'
require 'bundler/setup'
require 'twitch/chat'
require 'yaml'

config = YAML.load_file('config.yml')

puts config.inspect
puts config['bot_name']
puts config['password']
puts config['channel']


client = Twitch::Chat::Client.new(channel: config['channel'], nickname: config['bot_name'], password: config['password']) do

  on(:message) do |user, message|
    puts 'message'
    send_message message
  end
end

client.run!

