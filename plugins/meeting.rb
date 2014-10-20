require 'cinch'
require 'yaml'

class MeetingPlugin
    include Cinch::Plugin

    match 'meeting'

    def execute(m)
        begin
            info = YAML.load(File.read("#{m.channel == '##opennsm' ? 'nsm' : 'lug'}notes.yml"))
            # both YAML files are updated frequently by a cron job (the GitHub URL is added to the local copy only)
            m.reply("#{m.user.nick}: Here is some info about our next meeting:")
            m.reply("It will be at #{info['Meeting Info']}.")
            m.reply("This week's big talk is about #{info['Talks']['Big Talks'].keys.first}.")
            m.reply("For more info, go to #{info['Link']}.")
        rescue
            m.reply(Format(:red, 'Could not read latest meeting notes.'))
        end
    end
end
