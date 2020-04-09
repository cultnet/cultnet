{ On } = require "./on"
{ Send } = require "./send"
{ Reply } = require "./reply"

export { On, Send, Reply, regex, prefix }

function regex re
  (event, next) ->>
    m = re.exec event.text
    if not m then return
    event.args = m
    next!

function prefix p
  (event, next) ->>
    if not event.text.starts-with p then return
    event.text = event.text.substring p.length
    event.prefix = p
    next!
