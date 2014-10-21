require 'cinch'

class LuckDragon
    #** usage: `!luckdragon` **#
    #** Prints a picture of an asciiart luckdragon to the screen **#
    include Cinch::Plugin

    match 'luckdragon'

    def execute(m)
        m.reply("\n
    _mmmmmm__ mmmmmmm           mmmmmmmmmmm            
   T  _  |  ||       \_        /           b           
  /  (O) |  ||         \    __/    MMMMM   m        PL 
  (,___  |  ||MMMMM\    mmmmm    /'     M   m      / I 
    UD_) |  ||     M           /'      ed    m----I D  
    [__em|   |    D  M       /'       J   -_       M   
          \..'    M  MMMMMMMM        /   P  'MMMMMM    
                  T M                M  p'             
                 P  M                M  M              
                  MM                  MM'              ")
 
    end
end
