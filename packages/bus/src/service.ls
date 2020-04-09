uuid = require(\uuid).v4
{ create-client } = require \redis
{ Bus } = require "./bus"

BOTNET = process.env.BOTNET or \eggr
TIME_LIMIT = 15 * 1000

export Service = { request, host }

function request protocol, signal, arg, time-limit = TIME_LIMIT
  id = uuid!
  new Promise (resolve, reject) ->
    cancelled = false
    timeout = set-timeout do-timeout, time-limit
    function do-timeout
      cancelled := true
      cancel!
      reject (new Error "#{BOTNET}.request.#{protocol}: response time limit exceeded.")
    cancel = Bus.receive \respond, signal, protocol, (m) ->
      if m.id isnt id then return
      clear-timeout timeout
      cancel!
      if not m.success
        reject (new Error m.message)
      resolve m.value
    Bus.send \request, signal, protocol, { arg, id }

function host protocol, signal, respond
  Bus.receive \request, signal, ({ id, arg }) ->>
    try
      value = await respond arg
      Bus.send \respond, signal, protocol, { success: true, id, value }
    catch e
      console.log e
      Bus.send \respond, signal, protocol, { success: false, message: e.to-string! }
