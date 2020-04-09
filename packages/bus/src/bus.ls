{ create-client } = require \redis

BOTNET = process.env.BOTNET or \cultnet

export Bus = { send, receive }

pub = create-client 6379

function send type, signal, protocol, payload
  pub.publish "#{BOTNET}.#{type}.#{signal}.#{protocol}" (JSON.stringify payload)

function receive type, signal, protocol, subscriber
  sub = create-client 6379
  sub.on \pmessage (pattern, channel, payload) ->
    msg = JSON.parse payload
    [, msg.type, msg.signal, msg.protocol] = channel.split "."
    try subscriber msg
    catch e => console.log e
  sub.psubscribe "#{BOTNET}.#{type}.#{signal}.#{protocol}"
