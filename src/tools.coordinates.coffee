
module.exports.coordToN = (pos) -> pos.x * 50 + pos.y
module.exports.nToCoord = (n) ->
  y = n % 50
  return {x: (n-y) // 50, y: y}
