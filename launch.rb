#!/usr/bin/env ruby

require 'socket'
require 'require_all'

require_all 'plugins'

SOCKET = '/tmp/luggy.socket'

def get_plugins()
    IO.readlines('plist').map(&:strip).reject(&:empty?).map { |line| Object.const_get(line) }
end

bot = Cinch::Bot.new do
    configure do |c|
        c.nick = 'Luggy'
        c.realname = 'LUG Bot'
        c.user = 'luggy'
        c.server = 'irc.freenode.net'
        c.messages_per_second = 1
        c.channels = %w[##uiuclug ##opennsm]
        begin
            c.plugins.plugins = get_plugins()
        rescue
            puts 'Error loading plugins!'
            exit
        end
        c.password = gets.to_s.chomp
    end
end

bot.loggers.clear

Thread.abort_on_exception = true
bthread = Thread.new { bot.start }

Signal.trap('INT') { exit }

at_exit do
    bot.quit
    bthread.kill
end

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
            bthread.kill
            bthread = Thread.new { bot.start }
        when 'reload'
            get_plugins().each do |p|
                load p.instance_methods(false).map { |m| p.instance_method(m).source_location.first }.uniq[0]
            end
            require_all "plugins"
        when /^nick (?<nick>.+)$/
            bot.nick = $~[:nick]
        when /^join (?<chan>.+)$/
            bot.join($~[:chan])
        when /^part (?<chan>.+)$/
            bot.part($~[:chan])
        end
    end
end
