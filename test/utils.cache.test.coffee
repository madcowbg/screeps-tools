cache = require 'utils.cache'

beforeEach =>
  cache.invalidateMemoized()

test "check memoized function called correct # of times", ->
  fnRetUndef = jest.fn()
  fnRetUndef(i) for i in [1..20]
  expect(fnRetUndef.mock.calls.length).toBe(20)

  memoizedFun = cache.memoize "testUndef", (args...) ->
    fnRetUndef(args...)

  memoizedFun(i % 13) for i in [1..50]
  expect(fnRetUndef.mock.calls.length).toBe(20 + 13)

  fnRetDef = jest.fn()
  memoizedFun = cache.memoize "testDef", (x) ->
    fnRetDef()
    return x * 10
  memoizedFun(i % 8) for i in [1..20]
  expect(fnRetDef.mock.calls.length).toBe(8)

test "memoize should fail for invalid string or fun", ->
  expect(() -> cache.memoize null, (x) ->).toThrow()
  expect(() -> cache.memoize null, undefined).toThrow()
  expect(() -> cache.memoize "correct", undefined).toThrow()

test "memoize should fail on duplicate", ->
  expect(() -> cache.memoize "one", (x) ->).not.toThrow()#.toBeDefined()
  expect(cache.memoize "duplicate", (x) ->).toBeDefined()
  expect(() -> cache.memoize "duplicate", (x) ->).toThrow()

test "memoizaction results cache cleanup", ->
  fnRetDef = jest.fn()
  memoizedFun = cache.memoize "testDef", (x) ->
    fnRetDef()
    return x / 10

  memoizedFun(i % 7) for i in [1..50]
  expect(fnRetDef.mock.calls.length).toBe(7)
  cache.clearMemoizedResultsCache()
  memoizedFun(i % 8) for i in [1..50]
  expect(fnRetDef.mock.calls.length).toBe(7 + 8)

test "memoization invalidation", ->
  memoizedFun = cache.memoize "testDef", (x) -> return x / 11
  prevVal = memoizedFun(5)
  cache.invalidateMemoized()
  expect(() -> memoizedFun(5)).toThrow()
  expect(memoizedFun).toThrow()

  memoizedFun2 = cache.memoize "testDef", (x) -> return x * 10
  expect(memoizedFun2).not.toThrow()
  expect(memoizedFun2(5)).not.toBeCloseTo(prevVal)

test "memoization returns correct results", ->
  sz = 7
  valAs = (Math.random().toString() for i in [1..sz])
  valBs = (Math.random() for i in [1..sz])
  testFun = (a, b) -> {one: a, other: b*3 - 12}
  fnRetDef = jest.fn()
  memoizedFun = cache.memoize "testDef", (a, b) ->
    fnRetDef()
    return testFun(a, b)

  for i in [0...sz * 2 - 2]
    for j in [0...sz + 2]
      expect(memoizedFun(valAs[i % sz], valBs[j % sz])).toEqual(testFun(valAs[i % sz], valBs[j % sz]))

  expect(fnRetDef.mock.calls.length).toBe(sz * sz)
  tryBadCalls(undefined)
  tryBadCalls(null)
  tryBadCalls({})

tryBadCalls = (badVal) ->
  expect(() -> memoizedFun badVal).toThrow()
  expect(() -> memoizedFun badVal, 5).toThrow()
  expect(() -> memoizedFun "some", badVal).toThrow()
  expect(() -> memoizedFun valAs[0], valBs[1], badVal).toThrow()
