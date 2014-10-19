require 'cinch'

class StupidLogger < Cinch::Logger
    def initialize(bot)
        @bot = bot
    end

    def exception(e)
        if %x[git rev-parse --abbrev-ref HEAD].chomp == 'master'
            @bot.channels.each do |c|
                c.send(Cinch::Formatting.format(:red, 'Encountered exception. Switching to stable...'))
            end
            system('git checkout stable')
            PluginHelpers.reload_plugins(@bot)
        else
            @bot.channels.each do |c|
                c.send(Cinch::Formatting.format(:red, 'Error on stable.'))
            end
        end
    end

    def log(messages, event = nil, level = nil); end
end
