require 'cinch'


class Announce
    #** usage (PM the bot): `!announce <anything>` **#
    #** Makes an announcement in all channels the bot is in, given the announcer is an op in those channels **#
    include Cinch::Plugin

    set :react_on, :private
    match /announce\s+(.*)$/

    def execute(m, announcement)
        m.bot.channels.each do |c|
            if c.ops.include? m.user
                c.send(Format(:red, "Announcement: #{announcement}"))
            end
        end
    end
end
