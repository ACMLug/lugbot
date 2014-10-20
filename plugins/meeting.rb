require 'cinch'
require 'yaml/store'

class MeetingPlugin
    include Cinch::Plugin

    match 'meeting'

    def execute(m)
        begin
            m.reply("#{m.user.nick}: #{YAML.load(File.read('notes.yml'))['Meeting Info']}") # notes.yml is updated frequently by a cron job
        rescue
            m.reply(Format(:red, 'Could not read latest meeting notes.'))
        end
    end
end
