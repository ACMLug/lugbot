def match(f)
    if($tokens[0] == f)
        $tokens.shift
    else
        puts "Invalid"
        exit
    end
end

def get_next()
    if $tokens.count > 0
        $tokens.shift
    else
        raise
    end
end

def comment()
    comment = ""
    while $tokens[0] != "**#"
        comment += "#{get_next} "
    end
    match "**#"
    puts "#{comment}\n\n"
end

def comments()
    while $tokens[0] != "#**" and $tokens[0] != "class"
        get_next
    end
    while $tokens[0] == "#**"
        match "#**"
        comment
    end
end

def do_class()
    while $tokens[0] == "class"
        match "class"
        puts "## #{get_next}"
        comments
        while $tokens[0] != "class"
            get_next
        end
    end
end

files = Dir["plugins/*"]

files.each do |f|
    #puts "Checking #{f}"
    if /.rb$/.match(f)
        #puts "Generating #{f}"
        
        text = File.read(f)
#text = File.read("plugins/factoid.rb")
        
        $tokens = text.split(" ")
        
        while($tokens[0] != "class") 
            $tokens.shift 
        end
        begin
            do_class()
        rescue
        end
    end
end
