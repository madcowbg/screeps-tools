Queue = require 'tools.adt.queue'

test 'adding several elements', () ->
  q = new Queue()
  expect(q.getLength()).toBe(0)
  q.enqueue 7
  q.enqueue 5
  q.enqueue 5
  q.enqueue 7
  expect(q.getLength()).toBe 4
  expect(q.dequeue()).toBe 7
  q.enqueue 5
  expect(q.dequeue()).toBe 5
  expect(q.getLength()).toBe 3

test 'removing from empty queue', () ->
  q = new Queue()
  expect(q.dequeue()).toBeUndefined()
