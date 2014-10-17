require 'sqlite3'
require 'cinch'

class Markov
  #** Watches the channel and says things statistically likely to be said **#
  #** usage: `!markov [len]` **#
  #** Generates a phrase with the markov chain with the given length **#

  include Cinch::Plugin

  PARTS = 2

  ## CLASS THINGS
  class << self
    attr_accessor :db

    def initialize_class
      begin
        @db = SQLite3::Database.new "markov.db"
        @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS markov (
          id INTEGER PRIMARY KEY,
          phrase TEXT NOT NULL,
          next TEXT NOT NULL
        );
        SQL
        @db.execute "CREATE INDEX IF NOT EXISTS idx_markov_phrase ON markov(phrase)"

        @insert = @db.prepare "INSERT INTO markov (phrase, next) VALUES (?, ?)"
        @fetch = @db.prepare "SELECT next FROM markov WHERE phrase = ? LIMIT 1 OFFSET ?"
        @count = @db.prepare "SELECT count(*) FROM markov WHERE phrase = ?"
      rescue => e
        puts "Failed to initialize database #{e}"
        @db = nil
      end
    end

    # insert inserts a line into the markov chain
    def insert(phrase)
      if @db.nil?
        return
      end

      phrase.strip!
      phrase = [[""]*PARTS, phrase.split(/\s+/), ""].flatten

      phrase.each_cons(PARTS+1) do |chunk|
        begin
          @insert.execute chunk.take(PARTS).join(" "), chunk[-1]
        rescue
          puts "failed to insert into database"
        end
      end
    end

    # generate generates a phrase from the markov chain with a minimum of minlen tokens
    def generate(minlen=20)
      if @db.nil?
        return "database failed to open"
      end

      phrase = [""]*PARTS

      until phrase.length - PARTS >= minlen && phrase[-1] == ""
        first = phrase.last(PARTS)

        row = @count.execute! first.join(" ")
        if row.empty?
          return "failed to generate phrase"
        end

        unless row[0][0] > 0
          return "nothing in database"
        end

        sample = rand(row[0][0])
        row = @fetch.execute! first.join(" "), sample
        if row.empty?
          return "failed to generate phrase"
        end

        nextsym = row[0][0]
        if nextsym == ""
          phrase.concat [""]*PARTS
        else
          phrase.push nextsym
        end
      end

      return phrase.join(" ").gsub(/\s+/, " ").strip
    end

    # parse parses a file by line and adds associations to the markov chain
    def parse(file)
      if @db.nil?
        return
      end

      begin
        @db.transaction
        @db.execute "DROP INDEX IF EXISTS idx_markov_phrase"
        IO.readlines(file).map {|l| insert(l)}
        @db.execute "CREATE INDEX idx_markov_phrase ON markov(phrase)"
        @db.commit
      rescue
        puts "error reading #{file}"
        @db.rollback
      end
    end
  end

  ## BOT THINGS

  listen_to :message
  match /markov(?:\s+([0-9]+))?$/, :method => :respond

  def listen(m)
    if /^!markov/.match m.message
      return
    end

    if self.class.db.nil?
      return
    end

    if m.user == @bot.nick
      return
    end

    self.class.insert(m.message)
  end

  def respond(m, len)
    str = ""
    if self.class.db.nil?
      str = "error: could not connect to database"
    elsif len.nil? || len.empty?
      str = self.class.generate
    else
      str = self.class.generate len.to_i
    end

    m.reply "#{m.user}: #{str}"
  end

  initialize_class

end

if __FILE__ == $0
  if ARGV.length == 0
    puts "usage: markov.rb (parse FILE | generate NTOK)"
    exit
  end

  case ARGV.shift
  when 'parse'
    Markov.parse(ARGV.shift)
  when 'generate'
    if ARGV.length > 0
      puts Markov.generate(ARGV.shift.to_i)
    end
    puts Markov.generate
  else
    puts "invalid command"
    p ARGV
  end
end
