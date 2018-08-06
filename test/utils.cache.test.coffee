cache = require 'utils.cache'

afterEach =>
  cache.invalidateMemoized()

test "check memoized function called correct # of times", ->
  fnRetUndef = jest.fn()
  fnRetUndef(i) for i in [1..20]
  expect(fnRetUndef.mock.calls.length).toBe(20)

  memoizedFun = cache.memoize "testUndef", 1, (args...) ->
    fnRetUndef(args...)

  memoizedFun(i % 13) for i in [1..50]
  expect(fnRetUndef.mock.calls.length).toBe(20 + 13)

  fnRetDef = jest.fn()
  memoizedFun = cache.memoize "testDef", 1, (x) ->
    fnRetDef()
    return x * 10
  memoizedFun(i % 8) for i in [1..20]
  expect(fnRetDef.mock.calls.length).toBe(8)

test "memoize should fail for invalid string or fun", ->
  expect(() -> cache.memoize null, 1, (x) ->).toThrow()
  expect(() -> cache.memoize null, 1, undefined).toThrow()
  expect(() -> cache.memoize "incorrect", 1, undefined).toThrow()

test "memoize should fail on duplicate", ->
  expect(() -> cache.memoize "one", 1, (x) ->).not.toThrow()#.toBeDefined()
  expect(cache.memoize "duplicate", 1, (x) ->).toBeDefined()
  expect(() -> cache.memoize "duplicate", 2, (x) ->).toThrow()

test "memoizaction results cache cleanup", ->
  fnRetDef = jest.fn()
  memoizedFun = cache.memoize "testDef", 1, (x) ->
    fnRetDef()
    return x / 10

  memoizedFun(i % 7) for i in [1..50]
  expect(fnRetDef.mock.calls.length).toBe(7)

  expect(() -> memoizedFun2 = cache.memoize "testDef", 1, (x) -> return x * 10).toThrow()
  prevVal = memoizedFun(5)

  cache.invalidateMemoized()

  expect(() -> prevVal = memoizedFun(5)).toThrow()

  memoizedFun2 = cache.memoize "testDef", 1, (x) -> return x * 10
  expect(memoizedFun2(5)).not.toBeCloseTo(prevVal)

createMemoFun = (sz) ->
  valAs = (Math.random().toString() for i in [1..sz])
  valBs = (Math.random() for i in [1..sz])
  testFun = (a, b) -> {one: a, other: b*3 - 12}
  fnRetDef = jest.fn()
  memoizedFun = cache.memoize "testDef", 2, (a, b) ->
    fnRetDef()
    return testFun(a, b)

  callMemoed = (i, j) -> memoizedFun(valAs[i % sz], valBs[j % sz])
  callTestFun = (i, j) -> testFun(valAs[i % sz], valBs[j % sz])

  return [callMemoed, callTestFun, fnRetDef]

test "memoization returns correct results", ->
  [callMemoed, callTestFun, fnRetDef] = createMemoFun(sz=7)
  for i in [0...12]
    for j in [0...9]
      expect(callMemoed i, j).toEqual(callTestFun i, j)

  expect(fnRetDef.mock.calls.length).toBe(sz * sz)

test "memoized when called with bad params", ->
  memoizedFun = cache.memoize "testDef", 2, (a, b) -> return a + b
  expect(() -> memoizedFun()).toThrow()
  expect(() -> memoizedFun "some").toThrow()
  expect(memoizedFun "some", 5).toBeDefined()

  tryBadCalls = (badVal) ->
    expect(() -> memoizedFun badVal).toThrow()
    memoizedFun badVal, 5
    memoizedFun badVal, badVal
    memoizedFun "some", badVal
    expect(() -> memoizedFun valAs[0], valBs[1], badVal).toThrow()

  tryBadCalls(memoizedFun, undefined)
  tryBadCalls(memoizedFun, null)
  tryBadCalls(memoizedFun, {})

test "required functions are exported", ->
  expect(typeof cache.memoize).toBe "function"
  expect(typeof cache.memoizeForTick).toBe "function"
  expect(typeof cache.invalidateMemoized).toBe "function"

test "memoize for tick", ->
  fnRetDef = jest.fn((x) -> x * 10)

  memoizedFun = cache.memoizeForTick "testMemoizeForTick", 1, fnRetDef

  memoizedFun(i % 8) for i in [1..20]
  expect(fnRetDef.mock.calls.length).toBe(8)

  manipulation.Game.nextTick()
  memoizedFun(i % 6) for i in [1..20]
  expect(fnRetDef.mock.calls.length).toBe(8 + 6)
