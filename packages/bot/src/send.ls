{ Bus } = require (if process.env.CULTNET_LIVE is \true then \@cultnet/bus/src/bus else \@cultnet/bus)

export Send = { message }

function message protocol, source, text
  Bus.send \action \message protocol, { source, text }
