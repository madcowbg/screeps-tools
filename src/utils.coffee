module.exports.cton = (pos) -> pos.x * 50 + pos.y
module.exports.ntoc = (n) ->
  y = n % 50
  return {x: (n-y) // 50, y: y}

