require 'cinch'
require 'nokogiri'
require 'uri'

class TitlePlugin
    #** Automatically fetches the titles of URLs posted in chat **#
    include Cinch::Plugin

    match /(#{URI.regexp(%w[http https])})/, use_prefix: false

    def execute(m, uri)
        m.reply(Nokogiri::HTML(URI(uri).read).search('title').first.content) rescue nil
    end
end
