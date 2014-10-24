Testing the bot
===============

Clone the repository, and start/ssh into a Vagrant VM. Enter the `/vagrant` directory.
Create a file called `auth.json` with the contents

    {
        "password": "pass"
    }
where `pass` should be replaced with your `NickServ` password. If you don't have one,
ignore these instructions, and comment out the line `c.password = ...` in `launch.rb`.

Inside `launch.rb`, replace `Luggy` in the line `c.nick = 'Luggy'` with your nick for the test bot.
If you want to change the channels it joins, you can edit the line `c.channels = ...`, send it the commands
`join channel` or `part channel` (followed by newlines) to the Unix domain socket at `/tmp/luggy.socket` after it has launched, or both.

To run the bot, type `./launch.rb`.
