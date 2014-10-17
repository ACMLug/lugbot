require 'cinch'
require 'sqlite3'

$messages = Hash.new
$factdb = SQLite3::Database.new "lugbot.db"

begin
    $factdb.execute <<-SQL
        CREATE TABLE factoids (
            name TEXT PRIMARY KEY,
            factoid TEXT
        );
    SQL
rescue
end

class FactAdd
    #** usage: `!factadd <factoid name> <factoid>` **#
    #** Saves a factoid by name for later recall **#
    include Cinch::Plugin
    
    match /factadd\s+([a-zA-Z0-9]+)\s+(.+)$/
    
    def execute(m, factname, factoid)
        begin
            $factdb.execute("INSERT INTO factoids(name, factoid) VALUES (?, ?)", 
                             [factname, factoid])
            m.reply("Added factoid #{factname}", prefix=true)
        rescue
            m.reply("Couldn't add factoid #{factname}. Make sure a fact with that name doesn't already exist.", prefix=true)
        end
    end
end

class Factoid
    #** usage: `,<factoid name>` **#
    #** The bot will recite the factoid by name (if it exists) **#

    include Cinch::Plugin

    match /,([a-zA-Z0-9]+)\s*(.*)?$/, :use_prefix => false

    def execute(m, factname, nick)
        fact = $factdb.execute("select factoid from factoids 
                              where name = ?", factname)
        if fact.count == 0
            m.reply("Factoid #{factname} not found.")
        else
            fact.each do |row|
                if nick != ""
                    m.reply("#{nick}: #{row[0]}")
                else
                    m.reply("#{row[0]}")
                end
            end
        end
    end
end

class FactDel
    #** usage: `!factdel <factoid name>` **#
    #** Deletes a factoid from the factoid database by name **#
    include Cinch::Plugin

    match /factdel\s+([a-zA-Z0-9]+)/

    def execute(m, factname)
        fact = $factdb.execute("select factoid from factoids 
                              where name = ?", factname)
        if fact.count == 0
            m.reply("Factoid #{factname} not found.", prefix=true)
        else
            fact = $factdb.execute("delete from factoids
                                where name = ?", factname)
            m.reply("Deleted factoid #{factname}", prefix=true)
        end
    end
end
