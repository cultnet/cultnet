{ Bus } = require (if process.env.CULTNET_LIVE is \true then \@cultnet/bus/src/bus else \@cultnet/bus)
compose = require \koa-compose

export On = { message }

function message ...wares then middleware \message wares

function middleware signal, wares
  Bus.receive \event, signal, \*, (event) ->
    ((compose wares) event).catch console.log
