require 'cinch'
require 'yaml'

class MeetingPlugin
    #** usage: `!meeting` **#
    #** Returns details about the upcoming LUG or OpenNSM meeting **#
    include Cinch::Plugin

    match 'meeting'

    def execute(m)
        begin
            fname = "#{m.channel == '##opennsm' ? 'opennsm-' : ''}meetings/"
            info = YAML.load(File.read("../#{fname}current"))
            m.reply("#{m.user.nick}: Here is some info about our next meeting:")
            m.reply("It will be at #{info['Meeting Info']}.")
            m.reply("This week's big talk is about #{info['Talks']['Big Talks'].keys.first}.")
            urlprefix = "https://github.com/#{m.channel == '##opennsm' ? 'open-nsm' : 'ACMLug'}/meetings/blob/master/"
            pathsuffix = %x[readlink -f ../#{fname}/current].match(/\/home\/wqh\/#{fname}(.+)$/).captures.first
            m.reply("For more info, go to #{urlprefix}#{pathsuffix}.")
            
        rescue
            m.reply(Format(:red, 'Could not read latest meeting notes.'))
        end
    end
end
