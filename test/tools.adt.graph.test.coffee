{bfs, dijstraSlowDynamic, path} = require 'tools.adt.graph'

dummyGraph =
  1: [2, 3]
  2: [1]
  3: [1, 5, 4, 6]
  4: [3, 8]
  5: [2, 3]
  6: [3, 7]
  7: [8, 6]
  8: [4, 7]

vertex = (key) ->
  return
    label: key
    adjacent: () -> vertex ngh for ngh in dummyGraph[key]


dummyPath = (el, parent) ->
  pel.label for pel in (path el, parent)

test 'bfs on graph', ->
  bfsOrder = (el for el from bfs (vertex 1), (parent={}))
  expect(el.label for el in bfsOrder).toEqual [1, 2, 3, 5, 4, 6, 8, 7]

  paths = _.object([el.label, dummyPath el, parent] for el in bfsOrder)
  expect(paths).toMatchObject(
    4: [4, 3, 1]
    5: [5, 3, 1]
    6: [6, 3, 1]
    7: [7, 6, 3, 1]
    8: [8, 4, 3, 1])

test 'dijkstra on graph without terminal nodes', ->
  costFun = (a, b) -> 1
  isTerminalNode = (a) -> false

  terminalNode = dijstraSlowDynamic (vertex 1), costFun, isTerminalNode, dist={}, prev={}
  expect(terminalNode).not.toBeDefined()

  expect(dist).toMatchObject {
    "1": 0
    "2": 1
    "3": 1
    "4": 2
    "5": 2
    "6": 2
    "7": 3
    "8": 3
  }

  paths = _.object([l, dummyPath (vertex l), prev] for l in _.keys dist)
  expect(paths).toMatchObject {
    "1": ["1"]
    "2": ["2", 1]
    "3": ["3", 1]
    "4": ["4", 3, 1]
    "5": ["5", 3, 1]
    "6": ["6", 3, 1]
    "7": ["7", 6, 3, 1]
    "8": ["8", 4, 3, 1]
  }

test 'dijkstra on graph with two terminal nodes returns correct path', ->
  costFun = (a, b) -> 2
  isTerminalNode = (v) -> v.label == 6 or v.label == 7

  terminalNode = dijstraSlowDynamic (vertex 1), costFun, isTerminalNode, dist={}, prev={}
  expect(terminalNode.label).toBe 6

  expect(dummyPath terminalNode, prev).toMatchObject [6,3,1]

test 'dijkstra on graph with terminal node stops as soon as possible', ->
  costFun = (a, b) -> 2
  isTerminalNode = (v) -> v.label == 4

  terminalNode = dijstraSlowDynamic (vertex 1), costFun, isTerminalNode, dist={}, prev={}

  expect(terminalNode.label).toBe 4
  expect(prev[7]).not.toBeDefined()
  expect(prev[8]).not.toBeDefined()
