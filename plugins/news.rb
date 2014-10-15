require 'cinch'

require_relative '../lib/rssreader'

class NewsPlugin
    include Cinch::Plugin

    match 'news'

    def execute(m)
        begin
            RSSReader.summary('http://feeds.feedburner.com/linuxjournalcom?format=xml')[0..9].each { |item| m.reply(item) }
        rescue
            m.reply(Format(:red, 'Could not load news.'))
        end
    end
end
