#!/usr/bin/env ruby

require 'bundler/setup'
require 'cinch'
require 'socket'
require 'json'

SOCKET = '/tmp/luggy.socket'

module PluginHelpers
    def self.get_plugins
        Dir['plugins/*.rb', 'lib/*.rb'].each { |file| load file }
        IO.readlines('plist').map(&:strip).reject(&:empty?).map { |line| Object.const_get(line) }
    end

    def self.reload_plugins(bot)
        bot.plugins.unregister_all
        bot.plugins.register_plugins(get_plugins)
    end
end

bot = Cinch::Bot.new do
    configure do |c|
        c.nick = 'Luggy'
        c.realname = 'LUG Bot'
        c.user = 'luggy'
        c.server = 'irc.freenode.net'
        c.messages_per_second = 1
        c.channels = %w[##uiuclug ##opennsm]
        c.delay_join = 3
        c.plugins.plugins = PluginHelpers.get_plugins
        c.password = JSON.parse(File.read('auth.json'))['password']
    end
end

system('./redis-server redis.conf') unless File.exist?('/var/run/redis.pid')

bot.loggers.replace([StupidLogger.new(bot)])

Thread.abort_on_exception = true

Signal.trap('INT') { exit }

at_exit { bot.quit }

Thread.new { bot.start }

File.delete(SOCKET) if File.exist?(SOCKET)

UNIXServer.open(SOCKET) do |srv|
    conn = srv.accept

    loop do
        cmd = conn.gets
        if cmd.nil?
            conn.close
            conn = srv.accept
            next
        end

        case cmd.chomp
        when 'quit'
            exit
        when 'restart'
            bot.quit
            Thread.new { bot.start }
        when 'reload'
            PluginHelpers.reload_plugins(bot)
        when /^nick (?<nick>.+)$/
            bot.nick = $~[:nick]
        when /^join (?<chan>.+)$/
            bot.join($~[:chan])
        when /^part (?<chan>.+)$/
            bot.part($~[:chan])
        end
    end
end
