{ strip-colors, strip-colors-and-style } = require \irc-colors

export Format = { conform }

irc =
  bold: 0x02
  italic: 0x1D
  underline: 0x1F
  strike: 0x1E
  reverse: 0x16
  reset: 0x0F

irc-bold = charPattern irc.bold
irc-italic = charPattern irc.italic
irc-underline = charPattern irc.underline
irc-strike = charPattern irc.strike
irc-reverse = charPattern irc.reverse
irc-reset = charPattern irc.reset

md-bold = pattern "\\*\\*"
md-italic = pattern "\\*"
md-underline = pattern "__"
md-strike = pattern "~~"
md-block = pattern "```"
md-code = pattern "`"

function conform syntax, protocol, text
  if syntax is \irc
    if protocol is \discord
      irc-to-markdown text
    else if protocol is \telegram
      strip-colors-and-style text
    else
      text
  else if syntax is \md
    if protocol is \irccloud or protocol is \irc
      markdown-to-irc text
    else if protocol is \telegram
      strip-markdown text
    else
      text
  else
    return text

function strip-markdown text
  text
    .replace md-bold, ""
    .replace md-italic, ""
    .replace md-underline, ""
    .replace md-strike, ""

function irc-to-markdown text
  strip-colors text
    .replace irc-bold, "**"
    .replace irc-italic, "*"
    .replace irc-underline, "__"
    .replace irc-strike, "~~"
    .replace irc-reset, ""
    .replace irc-reverse, ""

function markdown-to-irc text
  text
    .replace md-bold, String.from-char-code irc.bold
    .replace md-italic, String.from-char-code irc.italic
    .replace md-underline, String.from-char-code irc.underline
    .replace md-strike, String.from-char-code irc.strike
    .replace md-block, ""
    .replace md-code, ""

function char-pattern code
  new RegExp (String.from-char-code code), \g

function pattern text
  new RegExp text, \g
