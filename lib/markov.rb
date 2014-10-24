require 'sqlite3'

class DatabaseError < StandardError
end

class Markov

  def initialize(parts)
    @parts = parts

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
  end

  # insert inserts a line into the markov chain
  def insert(phrase)
    phrase.strip!
    phrase = [[""]*@parts, phrase.split(/\s+/), ""].flatten

    phrase.each_cons(@parts+1) do |chunk|
      @insert.execute chunk.take(@parts).join(" "), chunk[-1]
    end
  end

  # generate generates a phrase from the markov chain with a minimum of minlen tokens
  def generate(minlen=20)
    minlen = minlen.to_i if minlen.is_a? String
    phrase = [""]*@parts

    until phrase.reject(&:empty?).length >= minlen && phrase[-1] == ""
      first = phrase.last(@parts).join " "

      row = @count.execute! first
      num_next = row.flatten.first
      raise DatabaseError, "inconsistent database state" if num_next.zero?

      row = @fetch.execute! first, rand(num_next)
      raise DatabaseError, "error sampling database" if row.empty?

      nextsym = row.flatten.first
      phrase.push nextsym
      phrase.push nextsym * @parts.pred if nextsym.empty?
    end

    return phrase.join(" ").gsub(/\s+/, " ").strip
  end

  # parse parses a file by line and adds associations to the markov chain
  def parse(file)
    begin
      @db.transaction
      @db.execute "DROP INDEX IF EXISTS idx_markov_phrase"
      IO.readlines(file).reject(&:empty?).map(&:strip).each {|l| insert(l)}
      @db.execute "CREATE INDEX idx_markov_phrase ON markov(phrase)"
      @db.commit
    rescue
      @db.rollback
      raise
    end
  end

end # Markov

if __FILE__ == $0
  markov = Markov.new 2

  cmd = ARGV.shift
  unless %w{generate insert parse}.include? cmd
    puts "usage: #{$0} (generate NTOK | insert PHRASE | parse FILE)"
    exit 1
  end

  begin
    ret = markov.send cmd, *ARGV
    puts ret if ret.is_a? String
  rescue => e
    puts "failed to do #{cmd}: #{e}"
  end
end
