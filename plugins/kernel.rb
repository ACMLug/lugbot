require 'cinch'
require 'json'
require 'open-uri'

class KernelPlugin
    #** usage: `!kernel` **#
    #** Displays the latest kernel version and changelog link **#
    include Cinch::Plugin

    match 'kernel'

    def execute(m)
        begin
            kerneldata = JSON.parse(URI('https://www.kernel.org/releases.json').read)
            m.reply("Latest kernel version: #{kerneldata['latest_stable']['version']}.")
            releases = kerneldata['releases']
            index = releases.find_index { |release| !release['changelog'].nil? }
            m.reply("Version #{releases[index]['version']} changelog: #{releases[index]['changelog']}.")
        rescue
            m.reply(Format(:red, 'There was an error fetching the data!'))
        end
    end
end
