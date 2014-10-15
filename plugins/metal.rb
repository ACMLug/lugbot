require 'cinch'
require 'redis'

class MetalPlugin
    include Cinch::Plugin

    def initialize(*args)
        super
        @db = Redis.new(driver: :hiredis)
    end

    match 'metal', method: :givemetal
    match /addmetal\s+(.+)$/, method: :addmetal
    match /delmetal\s+(.+)$/, method: :delmetal

    def givemetal(m)
        m.reply(@db.srandmember('metal', 1).first)
    end

    def addmetal(m, arg)
        unless @db.sismember('metal fans', m.user.nick)
            m.reply('Sorry, you are not an approved metal fan.')
            return
        end

        begin
            m.reply(@db.sadd('metal', arg) ? 'Rock on, dude.' : 'That song is already in the database.')
        rescue => e
            m.reply('Database full :(')
        end
    end

    def delmetal(m, arg)
        unless @db.sismember('metal fans', m.user.nick)
            m.reply('Sorry, you are not an approved metal fan.')
            return
        end

        m.reply(@db.srem('metal', arg) ? 'Song removed.' : "That song wasn't in the database.")
    end
end
