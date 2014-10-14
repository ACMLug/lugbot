require 'cinch'
require 'rss'

class RSSPlugin
    include Cinch::Plugin

    match /([a-z-]+\s+\d+)$/

    def execute(m, args)
        args = args.split(/\s+/)
        feed = args[0]
        num = args[1].to_i
        if num.zero?
            m.reply(Format(:red, 'You must load at least one article.'))
            return
        end

        begin
            rss = RSS::Parser.parse("http://seclists.org/rss/#{feed}.rss", true)
            rss.items.to_a[0..num.pred].each { |item| m.reply("#{item.title.gsub(/\s+/, ' ')} (#{item.link})") }
        rescue
            m.reply(Format(:red, "Could not load list #{feed}."))
        end
    end
end
