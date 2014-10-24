require 'cinch'

require_relative '../lib/markov.rb'


class MarkovPlugin
  #** Watches the channel and says things statistically likely to be said **#
  #** usage: `!markov [len]` **#
  #** Generates a phrase with the markov chain with the given length **#

  include Cinch::Plugin

  PARTS = 2

  def initialize(*args)
    super
    @markov = Markov.new PARTS rescue nil
  end

  listen_to :message
  match %r{markov(?:\s+([0-9]+))?$}, method: :respond

  def listen(m)
    return if @markov.nil?
    # ignore bot commands
    return if /^[!,].*/.match m.message
    # ignore things bot says
    return if m.user.nick.match @bot.nick

    @markov.insert m.message
  end

  def respond(m, len)
    m.reply Format(:red, "error connecting to markov database") and return if @markov.nil?

    len = len.to_i unless len.nil?

    begin
      str = @markov.generate(*len)
      m.reply "#{m.user}: #{str}"
    rescue => e
      m.reply Format(:red, "failed to generate phrase: #{e}")
    end
  end
end
