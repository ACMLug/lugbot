## MetalPlugin
`!metal` 

Prints a random song from the metal database 

`!addmetal <song>` 

Adds a metal song to the database 

`!delmetal <song>` 

Deletes a metal song from the database 

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

## QuoteGrab
usage: `!grab <nick>` 

Stores a quote of the last thing said by `<nick>` 

## Quote
usage: `!quote (<integer> | <nick>)` 

Gets a quote by id, or picks a random quote from `<nick>` 

## KernelPlugin
usage: `!kernel` 

Displays the latest kernel version and changelog link 

## FactAdd
usage: `!factadd <factoid name> <factoid>` 

Saves a factoid by name for later recall 

## Factoid
usage: `,<factoid name>` 

The bot will recite the factoid by name (if it exists) 

## FactDel
usage: `!factdel <factoid name>` 

Deletes a factoid from the factoid database by name 

