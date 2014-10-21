## MetalPlugin
`!metal` 

Prints a random song from the metal database 

`!addmetal <song>` 

Adds a metal song to the database 

`!delmetal <song>` 

Deletes a metal song from the database 

## HelpPlugin
usage: `!help` 

Returns a link to the documentation 

## MeetingPlugin
## Markov
Watches the channel and says things statistically likely to be said 

usage: `!markov [len]` 

Generates a phrase with the markov chain with the given length 

## <<
## SnortPlugin
usage: `!snort <query> <n>` 

Gets the first n rules from the snort ruleset whose messages contain the query string 

## LuckDragon
usage: `!luckdragon` 

Prints a picture of an asciiart luckdragon to the screen 

## SecurityPlugin
usage: `!security <n>` 

Fetches the latest n entries from CVEDetails 

## FortunePlugin
usage `!fortune` 

Tells you your fortune 

## NewsPlugin
usage: `!news [linux|bsd|osx]` 

Fetches the top 10 news items (optional argument restricts to a particular OS) 

## Dictionary
usage: `!define[+] <word or phrase> "|" <context>` 

Gets a definition (or multiple definitions) of a `<word or phrase>` 

`!define <word or phrase>` will get the definition. 

`!define+ <word or phrase>` will get all definitions. 

`!define <word or phrase> | <context>` will get a definition containing `<context>` 

## RSSPlugin
usage: `!seclist <list> <n>` 

Gets the latest n items from the given seclist feed 

## Announce
usage (PM the bot): `!announce <anything>` 

Makes an announcement in all channels the bot is in, given the announcer is an op in those channels 

## Quote
Grab and recall quotes by people in the channel 

usage: `!grab <nick>` 

Stores a quote of the last thing said by `<nick>` 

usage: `!quote (<integer> | <nick>)` 

Gets a quote by id, or picks a random quote from `<nick>` 

## KernelPlugin
usage: `!kernel` 

Displays the latest kernel version and changelog link 

## Factoid
Create, recall and delete factoids 

usage: `!factadd <factoid name> <factoid>` 

Saves a factoid by name for later recall 

usage: `,<factoid name>` 

The bot will recite the factoid by name (if it exists) 

usage: `!factdel <factoid name>` 

Deletes a factoid from the factoid database by name 

