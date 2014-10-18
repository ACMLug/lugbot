#!/usr/bin/env ruby

require 'bundler/setup'
require 'cinch'
require 'socket'
require 'json'

SOCKET = '/tmp/luggy.socket'

def get_plugins
    Dir['plugins/*.rb'].each { |plugin| load plugin }
    IO.readlines('plist').map(&:strip).reject(&:empty?).map { |line| Object.const_get(line) }
end

def reload_plugins(bot)
    bot.unregister_all
    bot.register_plugins(get_plugins)
    bot.start
end

system('redis') unless File.exist?('/var/run/redis.pid')

bot = Cinch::Bot.new do
    configure do |c|
        c.nick = 'Luggy'
        c.realname = 'LUG Bot'
        c.user = 'luggy'
        c.server = 'irc.freenode.net'
        c.messages_per_second = 1
        c.channels = %w[##uiuclug ##opennsm]
        c.delay_join = 3
        c.plugins.plugins = get_plugins
        c.password = JSON.parse(File.read('auth.json'))['password']
    end
end

Signal.trap('INT') { exit }

at_exit { bot.quit }

if %x[git branch].include?('master')
    begin
        bot.start
    rescue
        bot.channels.each do |c|
            c.send(Format(:red, 'Encountered exception. Switching to stable...'))
        end
        #system('git checkout stable')
        reload_plugins(bot)
    end
end
