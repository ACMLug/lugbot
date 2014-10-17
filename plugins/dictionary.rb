require 'cinch'
require 'wordnet'

class Dictionary
    #** usage: `!define[+] <word or phrase> "|" <context>` **#
    #** Gets a definition (or multiple definitions) of a `<word or phrase>` **#
    #** `!define <word or phrase>` will get the definition. **#
    #** `!define+ <word or phrase>` will get all definitions. **#
    #** `!define <word or phrase> | <context>` will get a definition containing `<context>` **#
    
    include Cinch::Plugin
    
    match /define([+])?\s+([a-zA-Z\s]+)\|?\s*([a-zA-Z\s]*)$/

    def execute(m, all, word, context)
        word.strip!
        context.strip!
        if context != "" then
            lookupcontext(m, word, context)
        elsif all == "+" then
            lookupall(m, word)
        else
            lookup(m, word)
        end
    end

    def lookupall(m, word)
        lex = WordNet::Lexicon.new
        synset = lex.lookup_synsets(word.to_sym)
        if synset.count > 0 then
            synset.each do |s|
                write_synset(m,s)
            end
        else
            m.reply("'#{word}' not found.")
        end
    end

    def lookupcontext(m, word, context)
        lex = WordNet::Lexicon.new
        synset = lex.lookup_synsets(word.to_sym, context)
        if synset.count > 0 then
            synset.each do |s|
                write_synset(m,s)
            end
        else
            m.reply("'#{word}' not found in context '#{context}'.")
        end
    end

    def lookup(m, word)
        lex = WordNet::Lexicon.new
        synset = lex[word.to_sym]
        if synset != nil then
            write_synset(m,synset)
        else
            m.reply("'#{word}' not found.")
        end
      
    end

    def write_synset(m, s)
        m.reply("%s (%s): %s" % 
                [
                 s.words.map( &:to_s ).join(', '),
                 s.part_of_speech,
                 s.definition
                ])
    end
end
