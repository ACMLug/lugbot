require 'cinch'

require_relative '../lib/rssreader'

class NewsPlugin
    include Cinch::Plugin

    LINUX_NEWS = ['http://feeds.feedburner.com/linuxjournalcom?format=xml']
    BSD_NEWS = ['http://www.bsdnewsletter.com/newsfeeds/bsdnewsletter.rdf']
    OSX_NEWS = [
        'http://feeds.feedburner.com/osxdaily?format=xml',
        'http://www.macworld.com/index.rss'
    ]

    match /news(?:\s+(.+))?$/

    def execute(m, arg)
        begin
            case arg
            when 'linux'
                sources = LINUX_NEWS
            when 'bsd'
                sources = BSD_NEWS
            when 'osx'
                sources = OSX_NEWS
            else
                sources = LINUX_NEWS + BSD_NEWS + OSX_NEWS
            end
            news = []
            sources.each { |source| news += RSSReader.getitems(source) }
            news.sort! { |a, b| b.date.to_i <=> a.date.to_i }
            RSSReader.format(news[0..9]).each { |n| m.reply(n) }
        rescue
            m.reply(Format(:red, 'Could not load news.'))
        end
    end
end
