require 'cinch'


class Announce
    include Cinch::Plugin

    set :react_on, :private
    match /announce\s+(.*)$/

    def execute(m, announcement)
        m.bot.channels.each do |c|
            c.send(Format(:red, "Announcement: #{announcement}"))
        end
    end
end
