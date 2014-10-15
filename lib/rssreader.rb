require 'rss'

module RSSReader
    def self.summary(feed)
        RSS::Parser.parse(feed, true).items.map { |item| "#{item.title.gsub(/\s+/, ' ')} (#{item.link})" }
    end
end
