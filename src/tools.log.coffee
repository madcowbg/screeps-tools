
bold = (msg) -> "<b>#{msg}</b>"
ital = (msg) -> "<i>#{msg}</i>"
color = (color) -> (msg) -> "<font color='#{color}'>#{msg}</font>"

tickLog = () -> console.log(((color "#444") "[#{Game.time}]") + toStr arguments)

toStr = (args) ->
  #  console.log args
  if args.length == 1 then args[0] else (Array.prototype.slice.call(args).join ",")

module.exports.important = () ->
  tickLog (color "blue") bold toStr arguments

if Memory.switches?.log?.showInfo
  module.exports.info = () -> tickLog (color "grey") ital toStr arguments

module.exports.warn = () ->
  tickLog (color "yellow") toStr arguments

module.exports.error = () ->
  tickLog (color "red") bold toStr arguments

module.exports.debug = () ->
  tickLog (color "green") toStr arguments

module.exports.trace = () ->
  tickLog (color "green") toStr arguments

if Memory.switches?.log?.showLore
  module.exports.lore = () -> tickLog (color "teal") toStr arguments

module.exports.assert = (condition, args...) ->
  unless condition == true
    module.exports.error toStr args
    throw new Error "AssertionError: #{toStr args}"
