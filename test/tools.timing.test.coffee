{decorateWithTiming, getTiming} = require 'tools.timing'

beforeEach ->
  global.Game =
    cpu:
      getUsed: () -> Game._ct
    _ct: 2.3

expectTiming = (obj, field, singleRunCPU) ->
  expect(getTiming field, obj).toBeCloseTo 0
  obj.fun()
  expect(getTiming field, obj).toBeCloseTo singleRunCPU
  obj.fun() for z in [1...7]
  expect(getTiming field, obj).toBeCloseTo singleRunCPU*7

test 'add timing to class method', ->
  obj =
    memory: {}

  singleRunCPU = 2.1
  obj.fun = decorateWithTiming "_theTime", (fnObj = jest.fn -> Game._ct += singleRunCPU)

  expectTiming obj, "_theTime", singleRunCPU
  expect(fnObj).toBeCalledTimes 7

test 'add timing to prototype method', ->
  Game._ct = 20
  singleRunCPU = 3.7
  class Thing
    constructor: () -> @memory = {}

  thing = new Thing()
  Thing::fun = decorateWithTiming "_theTime2", (fnThing = jest.fn -> Game._ct += singleRunCPU)

  expectTiming thing, "_theTime2", singleRunCPU
  expect(fnThing).toBeCalledTimes 7
