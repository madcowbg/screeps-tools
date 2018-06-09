
bold = (msg) -> "<b>#{msg}</b>"
ital = (msg) -> "<i>#{msg}</i>"
color = (color) -> (msg) -> "<font color='#{color}'>#{msg}</font>"

tickLog = (msg) -> console.log (((color "#444") "[#{Game.time}]") + msg)

module.exports.important = (msg) ->
  tickLog (color "blue") bold msg

if Memory.showInfo
  module.exports.info = (msg) -> tickLog (color "grey") ital msg

module.exports.warn = (msg) ->
  tickLog (color "yellow") msg

module.exports.error = (msg) ->
  tickLog (color "red") bold msg

module.exports.debug = (msg) ->
  tickLog (color "green") msg

module.exports.lore = (msg) ->
  tickLog (color "teal") msg

module.exports.assert = (condition, msg) ->
  unless condition == true
    module.exports.error msg
    throw new Error "AssertionError: #{msg}"