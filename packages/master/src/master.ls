{ promisify } = require \util
{ resolve } = require \path
{ watch } = require \chokidar
{ values, map } = require \prelude-ls
spawn = require \spawn-command
tree-kill = require \tree-kill |> promisify
death = require \death

export Master = { start }

master-dir = resolve "#{__dirname}/.."
slave-bin = "#{master-dir}/node_modules/@cultnet/slave/bin/cultnet-slave"
slaves = {}

function start { dir, name, patterns, requires, lsc }
  name ?= \cultnet
  patterns ?= ["**/*.slave.ls" "**/*.slave.ts" "**/*.slave.js"]
  console.log "starting botnet #{name} at #{dir} watching #{patterns}"
  process.chdir dir
  doom-slaves!
  watcher = watch patterns, { cwd: dir, ignored: /node_modules/ }
  watcher.on \add (path) -> add-slave path, requires, lsc
  watcher.on \unlink remove-slave

function add-slave path, requires, lsc
  if not /\.slave\./.test path then return
  console.log "adding slave #{path}"
  r-args = if requires.length is 0 then "" else requires.map((r) -> "-r #{r}").join " "
  cmd = "#{slave-bin} #{r-args} --respawn --no-notify #{path}"
  env = process.env
  if lsc then env.CULTNET_LSC = \true
  console.log "$ " + cmd
  slave =
    process: spawn cmd, { stdio: \inherit, +detached, env }
  slaves[path] = slave
  slave.process.on \exit ->
    console.log "slave died #{path}"
    delete slaves[path]

async function remove-slave path
  slave = slaves[path]
  if not slave then return
  console.log "removing slave #{path}"
  tree-kill slave.process.pid, \SIGKILL

function doom-slaves
  death ->
    slaves |> values
    |> map ({ process }) -> tree-kill process.pid, \SIGKILL
    |> Promise.all
      ..then -> process.exit!
