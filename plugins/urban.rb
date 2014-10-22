require 'cinch'
require 'json'
require 'uri'

class UrbanPlugin
    #** usage: `!urban <phrase> [n]` **#
    #** Gives the correct definition(s) of `<phrase>` with examples **#
    include Cinch::Plugin

    DEFINE_URL = 'http://api.urbandictionary.com/v0/define?term='

    match /urban\s+(.+?)(?:\s+(\d+))?$/

    def execute(m, phrase, num)
        unless num.nil?
            num = num.to_i
            if num.zero?
                m.reply(Format(:red, 'Must specify a nonzero number of definitions.'))
                return
            end
        end

        begin
            results = JSON.parse(URI(URI.encode("#{DEFINE_URL}#{phrase}")).read)

            if results['result_type'] == 'no_results'
                m.reply(Format(:red, "No definitions found for #{phrase}."))
                return
            end

            results['list'][0..(num.nil? ? 0 : num.pred)].each do |defn|
                m.reply("#{Format(:aqua, 'Definition:')} #{defn['definition']}")
                m.reply("#{Format(:purple, 'Example:')} #{defn['example']}")
            end
        rescue
            m.reply(Format(:red, 'Could not retrieve definitions.'))
        end
    end
end
