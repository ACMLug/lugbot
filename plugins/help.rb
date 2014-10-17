require 'cinch'

class HelpPlugin
    #** usage: `!help` **#
    #** Returns a link to the documentation **#
    include Cinch::Plugin

    match 'help'

    def execute(m)
        m.reply('https://github.com/ACMLug/lugbot/blob/master/doc.md')
    end
end
