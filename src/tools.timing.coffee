
module.exports.decorateWithTiming = (fieldname, f) -> () ->
  start = Game.cpu.getUsed()
  try
    f.apply(@, arguments)
  catch e
    throw new Error e
  finally
    @memory[fieldname] ?= 0
    @memory[fieldname] += Game.cpu.getUsed() - start

module.exports.getTiming = (fieldname, obj) -> obj.memory[fieldname] ?= 0
