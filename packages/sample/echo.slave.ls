{ On, Reply, regex } = require \@cultnet/bot

On.message do
  regex /^echo\s+(.+)/i
  Reply.message ({ nick, args }) -> args.1
