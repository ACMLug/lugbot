## FortunePlugin
## NewsPlugin
## MetalPlugin
## RSSPlugin
## QuoteGrab
usage: `!grab <nick>` 

Stores a quote of the last thing said by `<nick>` 

## Quote
usage: `!quote (<integer> | <nick>)` 

Gets a quote by id, or picks a random quote from `<nick>` 

## SecurityPlugin
## Dictionary
usage: `!define[+] <word or phrase> "|" <context>` 

Gets a definition (or multiple definitions) of a `<word or phrase>` 

`!define <word or phrase>` will get the definition. 

`!define+ <word or phrase>` will get all definitions. 

`!define <word or phrase> | <context>` will get a definition containing `<context>` 

## KernelPlugin
## FactAdd
usage: `!factadd <factoid name> <factoid>` 

Saves a factoid by name for later recall 

## Factoid
usage: `,<factoid name>` 

The bot will recite the factoid by name (if it exists) 

## FactDel
usage: `!factdel <factoid name>` 

Deletes a factoid from the factoid database by name 

## Announce
usage (PM the bot): `!announce <anything>` 

Makes an announcement in all channels the bot is in, given the announcer is an op in those channels 

