require 'cinch'

class FortunePlugin
    #** usage `!fortune` **#
    #** Tells you your fortune **#
    include Cinch::Plugin

    match 'fortune'

    def execute(m)
        m.reply(%x[fortune].gsub(/\s+/, ' '))
    end
end
