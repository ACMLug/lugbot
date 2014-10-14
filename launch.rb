#!/usr/bin/env ruby

require 'socket'
require 'require_all'

require_all 'plugins'

bot = Cinch::Bot.new do
    configure do |c|
        c.nick = 'Luggy'
        c.realname = 'LUG Bot'
        c.user = 'luggy'
        c.server = 'irc.freenode.net'
        c.password = gets.to_s.chomp
        c.messages_per_second = 1
        c.channels = %w[##uiuclug ##opennsm]
        c.plugins.plugins = [RSSPlugin, KernelPlugin]
    end
end

bot.loggers.clear

bthread = Thread.new { bot.start }

Signal.trap('INT') { exit }

at_exit do
    bot.quit
    bthread.kill
    File.delete('/tmp/luggy.socket')
end

UNIXServer.open('/tmp/luggy.socket') do |srv|
    conn = srv.accept

    loop do
        cmd = conn.gets
        exit if cmd.nil?

        case cmd.chomp
        when 'quit'
            exit
        when 'restart'
            bot.quit
            bthread.kill
            bthread = Thread.new { bot.start }
        when /^nick (?<nick>.+)$/
            bot.nick = $~[:nick]
        when /^join (?<chan>.+)$/
            bot.join($~[:chan])
        when /^part (?<chan>.+)$/
            bot.part($~[:chan])
        end
    end
end
