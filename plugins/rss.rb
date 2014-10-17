require 'cinch'

require_relative '../lib/rssreader'

class RSSPlugin
    #** usage: `!seclist <list> <n>` **#
    #** Gets the latest n items from the given seclist feed **#
    include Cinch::Plugin

    match /seclist\s+([a-z-]+)\s+(\d+)$/

    def execute(m, feed, num)
        num = num.to_i
        if num.zero?
            m.reply(Format(:red, 'You must load at least one article.'))
            return
        end

        begin
            RSSReader.summary("http://seclists.org/rss/#{feed}.rss")[0..num.pred].each { |item| m.reply(item) }
        rescue
            m.reply(Format(:red, "Could not load list #{feed}."))
        end
    end
end
