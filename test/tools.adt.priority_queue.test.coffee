PriorityQueue = require 'tools.adt.priority_queue'

test "invalid heap ops", ->
  expect(() -> new PriorityQueue()).toThrow()
  expect(() -> new PriorityQueue("5")).toThrow()
  expect(heap = new PriorityQueue((i) -> i * i - 5 * i)).toBeDefined()
  expect(heap.size()).toBe 0
  expect(() -> heap.top()).toThrow() # empty heap...
  expect(() -> heap.pop()).toThrow() # empty heap...

rndData = () ->
  f = (i) -> (i + 5) * (i - 5)
  vals = ((Math.random() * 20 - 10) for i in [1..50])
  return [f, vals]

test "push/pop unique to heap", ->
  [f, vals] = rndData()
  heap = new PriorityQueue(f)
  heap.push val for val in vals
  expect(heap.size()).toBe vals.length

  vs = (heap.pop() while heap.size() > 0)
  expect(vs).toEqual(_.sortBy vals, f)

test "push/remove unique to heap", ->
  [f, vals] = rndData()
  heap = new PriorityQueue(f)
  heap.push val for val, i in vals when i < 10
  expect(heap.size()).toBe 10
  heap.remove(val) for val, i in vals when i < 5
  expect(heap.size()).toBe 5
  heap.remove(-100)
  expect(heap.size()).toBe 5
  heap.push val for val, i in vals when 10 <= i
  expect(heap.size()).toBe 45

test "push/pop/remove duplicates to heap", ->
  [f, _vals] = rndData()
  heap = new PriorityQueue(f)
  heap.push v for v in [2, 3, 2, 2, 3, 5, 6]
  expect(heap.size()).toBe 7
  heap.remove 2
  heap.remove 2
  heap.remove 2
  expect(heap.size()).toBe 4
  heap.push 2
  expect(heap.size()).toBe 5
  heap.remove 3
  expect(heap.size()).toBe 4
  expect(heap.top()).toBe 2
  expect(heap.pop() while heap.size() > 0).toEqual [2, 3, 5, 6]
