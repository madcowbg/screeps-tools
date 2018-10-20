{coordToN, nToCoord} = require 'tools.coordinates'

test "coordinate to number", ->
  nums = []
  for x in [1, 3, 8]
    for y in [0, 20, 42]
      nums.push coordToN {x, y}

  expect(nums).toEqual [50, 70, 92, 150, 170, 192, 400, 420, 442]

test "number to coordinate", ->
  coords = (nToCoord n for n in _.range 7, 49*49, 133)
  expect(coords).toEqual [
    {x: 0, y: 7}, {x: 2, y: 40}, {x: 5, y: 23}, {x: 8, y: 6}, {x: 10, y: 39},
    {x: 13, y: 22}, {x: 16, y: 5}, {x: 18, y: 38}, {x: 21, y: 21}, {x: 24, y: 4},
    {x: 26, y: 37}, {x: 29, y: 20}, {x: 32, y: 3}, {x: 34, y: 36}, {x: 37, y: 19},
    {x: 40, y: 2}, {x: 42, y: 35}, {x: 45, y: 18}]

rndXY = () -> {
  x: Math.floor(Math.random() * 50)
  y: Math.floor(Math.random() * 50)
}
rndN = () -> Math.floor(Math.random() * 2500)
test "random coordinates to and from", ->
  for z in [0..100]
    coords = rndXY()
    expect(nToCoord coordToN coords).toMatchObject coords
    n = rndN()
    expect(coordToN nToCoord n).toBe n
  return
