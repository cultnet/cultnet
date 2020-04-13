require! optionator
require! \escape-string-regexp

export Command = { parse }

function parse name, settings
  command = optionator settings
  regex = new RegExp "^" + (escape-string-regexp name).replace /\ /g "\\s+"
  (event, next) ->>
    if not regex.test event.text then return
    # TODO: fix substring
    event.command = command.parse (event.text.substring name.length)
    await next!

function simple string
  \TODO
