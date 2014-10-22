require 'cinch'
require 'uri'

class SnortPlugin
    #** usage: `!snort <query> <n>` **#
    #** Gets the first n rules from the snort ruleset whose messages contain the query string **#
    include Cinch::Plugin

    RULESET = 'http://rules.emergingthreats.net/open/snort-2.9.0/emerging-all.rules'

    match /snort\s+(.+)\s+(\d+)$/

    def execute(m, query, num)
        num = num.to_i
        if num.zero?
            m.reply(Format(:red, 'Must specify a nonzero number of rules to fetch.'))
            return
        end

        begin
            matches = URI(RULESET).read.scan(/(alert|log|pass|activate|dynamic|drop|reject|sdrop).+?rev:\d+;\)/)
            rules = []
            matches.map { |text| text.match(/msg:"(.+?)(?<!\\)"/).to_a[1] }.compact.each_with_index do |str, i|
                rules << matches[i] if str.downcase.include?(query.strip.downcase)
            end

            rules[0..num.pred].each { |rule| m.reply(rule) }
        rescue
            m.reply(Format(:red, 'Error fetching rules.'))
        end
    end
end
