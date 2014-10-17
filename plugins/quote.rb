require 'cinch'
require 'sqlite3'

$messages = Hash.new
$quotedb = SQLite3::Database.new "lugbot.db"

begin
    $quotedb.execute <<-SQL
        CREATE TABLE quotes (
            id INTEGER PRIMARY KEY,
            nick TEXT,
            quote TEXT
        );
    SQL
rescue
end

class QuoteGrab
    include Cinch::Plugin
    
    listen_to :message
    match /grab\s+(.+)$/

    def listen(m)
        if /^!grab/.match(m.message)
            return
        end
        $messages[m.user.nick] = m.message
    end

    def execute(m, nick)
        if $messages[nick]
            $quotedb.execute("INSERT INTO quotes(nick, quote) VALUES (?, ?)", 
                             [nick, $messages[nick]])

            $quotedb.execute("select max(id) as id from quotes") do |row|
                m.reply("Quote #{row[0]}: #{nick}: #{$messages[nick]}")
            end
        else
            m.reply("No quote available for #{nick}")
        end
    end
end

class Quote
    include Cinch::Plugin

    match /quote\s+([0-9]*)(.*)$/

    def execute(m, quoteid, nick)
        
        if quoteid != ""
           
            quotes = $quotedb.execute("select nick, quote from quotes 
                              where id = ?", quoteid)
            if quotes.count == 0
                m.reply("Quote #{quoteid} not found.")
            else
                quotes.each do |row|
                    m.reply("#{row[0]}: #{row[1]}")
                end
            end
        else
            quotes = $quotedb.execute("select id, quote from quotes 
                                       where nick like ?", nick)

            if quotes.count == 0
                m.reply("No quotes found for #{nick}")
            else
                rnd = rand(quotes.count)
                m.reply("(#{quotes[rnd][0]}) #{nick}: #{quotes[rnd][1]}")
            end
        end
    end
end
