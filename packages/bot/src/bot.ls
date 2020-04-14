koa-compose = require \koa-compose

{ On } = require "./on"
{ Send } = require "./send"
{ Reply } = require "./reply"

Event = { compose, regex, prefix, not-mine, extend }

export { On, Send, Reply, Event }

function compose ...wares then koa-compose wares

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

function not-mine p
  (event, next) ->>
    if event.is-mine then return
    next!

function extend create-props
  (event, next) ->>
    Object.assign event, create-props event
    next!