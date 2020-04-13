require! { path: { resolve } }
require! { fs: { exists-sync: exists }}
require! optionator

command = optionator do
  prepend: "Usage: cultnet [dir]"
  options: [
    { option: \name, alias: \n, type: \String, description: "botnet name" }
    { option: \pattern, alias: \p, type: "[String]", +concat-repeated-arrays, description: "specify watch pattern(s)" }
    { option: \require, alias: \r, type: "[String]", +concat-repeated-arrays, description: "require module(s) before execution" }
    { option: \help, alias: \h, type: \Boolean, description: "displays help" }
    { option: \lsc, type: \Boolean, +hidden }
  ]

options = command.parse-argv process.argv
if options.lsc then options._.shift!
if options.help then console.log command.generate-help!; process.exit 1

dir = if options.0 then resolve options.0 else process.cwd!
if not exists dir then console.log "cannot find directory #{dir}"; process.exit 1

cultnet-json = "#{dir}/cultnet.json"
package-json = "#{dir}/package.json"
tsconfig-json = "#{dir}/tsconfig.json"

settings = {}
pkg = {}

if exists cultnet-json
  settings := require cultnet-json
else if exists package-json
  pkg := require package-json
  settings := pkg.cultnet or {}

config =
  name: options.name or settings.name or pkg.name or null
  dir: dir
  tsconfig: options.tsconfig or settings.tsconfig or null
  lsc: options.lsc
  patterns:
    if options.pattern then options.pattern
    else if settings.patterns then settings.patterns
    else null
  requires: [...(options.require or []), ...(settings.require or [])]

master-src = resolve "#{__dirname}/../node_modules/@cultnet/master/src/master"

{ Master } = if options.lsc then require master-src
else require \@cultnet/master

Master.start config
