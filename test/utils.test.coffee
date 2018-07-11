utils = require 'utils'

rndPos = () -> {x: Math.floor(Math.random() * 50), y: Math.floor(Math.random() * 50)}

test 'testing bijection', () ->
  for i in [1..100]
    pos = rndPos()
    npos = utils.cton pos
    expect(npos).toBeLessThan 5000
    expect(npos).toBeGreaterThanOrEqual 0
    expect(utils.ntoc npos).toEqual pos
  return undefined

test 'testing exact values', () ->
  expect(utils.ntoc 922).toEqual {x:18, y:22}
  expect(utils.ntoc 1518).toEqual {"x":30,"y":18}
  expect(utils.ntoc 1373).toEqual {"x":27,"y":23}
  expect(utils.ntoc 246).toEqual {"x":4,"y":46}
