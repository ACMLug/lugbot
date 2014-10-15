require 'cinch'

class FortunePlugin
    include Cinch::Plugin

    match 'fortune'

    def execute(m)
        m.reply(%x[fortune].gsub(/\s+/, ' '))
    end
end
