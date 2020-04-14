{ promisify } = require \util
{ On, Reply, Event } = require (if process.env.CULTNET_LSC is \true then \@cultnet/bot/src/bot else \@cultnet/bot)
{ Format } = require (if process.env.CULTNET_LSC is \true then \@cultnet/format/src/format else \@cultnet/format)
weather-js = require(\weather-js).find |> promisify

export Weather = { fetch, get-emoji, pattern, reply, trigger, weather-text, forecast-text }

function trigger then Event.compose pattern!, reply!

function pattern
  Event.compose do
    Event.regex /^(weather|forecast)\s+(-c\s+)?(.+)/i
    Event.extend ({ args }) -> request:
      type: args.1.to-lower-case!
      search: args.3
      degree-type: if args.2 then \C else \F

function reply
  Reply.message ({ nick, protocol, request }) ->>
    { type, search, degree-type } = request
    result = await fetch search, degree-type
    if not result then return "#{nick}: couldn't find '#{search}'"
    text =
      if type is \weather then weather-text result, degree-type
      else forecast-text result, degree-type
    Format.conform \md, protocol, text

async function fetch search, degree-type
  results = await weather-js { search, degree-type }
  if results.length is 0 then return null
  return results.0

function weather-text { current, forecast, location }, degree-type
  temp = current.temperature + degree-type
  today = forecast.0
  high = today.high + degree-type
  low = today.low + degree-type
  cond = current.skytext
  wind = current.winddisplay
  humid = current.humidity + "%"
  icon = get-emoji current.skycode
  """
#{icon} **#{temp}** and **#{cond}** in __#{location.name}__
High: **#{high}**, Low: **#{low}**
Humidity: **#{humid}**, Wind: **#{wind}**
  """

function forecast-text { current, forecast, location }, degree-type
  days = forecast
    .map (d) ->
      emoji = get-emoji d.skycodeday
      "#{emoji} #{d.shortday} **#{d.high}#{degree-type}** *(#{d.low}#{degree-type})*"
    .join "\n"
  """
**Forecast** for __#{location.name}__
#{days}
  """

function get-emoji code
  switch code
  | \0 => "🌩"
  | \1 => "🌩"
  | \2 => "🌩"
  | \3 => "🌩"
  | \4 => "🌩"
  | \5 => "🌨"
  | \6 => "🌧"
  | \7 => "🌨"
  | \8 => "🍆"
  | \9 => "🌧"
  | \10 => "🌨"
  | \11 => "🌧"
  | \12 => "🌧"
  | \13 => "🌨"
  | \14 => "🌨"
  | \15 => "🌨"
  | \16 => "🌨"
  | \17 => "🌩"
  | \18 => "🌧"
  | \20 => "🌁"
  | \21 => "🌁"
  | \22 => "🌁"
  | \23 => "🌬"
  | \24 => "🌬"
  | \26 => "☁️"
  | \27 => "⛅️"
  | \28 => "⛅️"
  | \29 => "⛅️"
  | \30 => "⛅️"
  | \31 => "🌙"
  | \32 => "☀️"
  | \33 => "⛅️"
  | \34 => "⛅️"
  | \35 => "🌩"
  | \36 => "☀️"
  | \37 => "⛈"
  | \38 => "⛈"
  | \39 => "⛅️"
  | \40 => "🌧"
  | \41 => "⛅️"
  | \42 => "🌨"
  | \43 => "🌨"
  | \45 => "⛅️"
  | \46 => "⛅️"
  | \47 => "⛈"
  | otherwise => "🍆"