{ Send } = require "./send"

export Reply = { message }

function message fn
  (event) ->>
    if event.is-mine then return
    text = await Promise.resolve (fn event)
    Send.message event.protocol, event.source, text
