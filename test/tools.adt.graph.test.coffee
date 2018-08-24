_ = require 'lodash'

{bfs, path} = require 'tools.adt.graph'

dummyGraph =
  1: [2, 3]
  2: [1]
  3: [1, 5, 4, 6]
  4: [3, 8]
  5: [2, 3]
  6: [3, 7]
  7: [8, 6]
  8: [4, 7]

edge = (key) ->
  return
    label: key
    adjacent: () -> edge ngh for ngh in dummyGraph[key]

test 'bfs on graph', ->
  bfsOrder = (el for el from bfs (edge 1), (parent={}))
  expect(el.label for el in bfsOrder).toEqual [1, 2, 3, 5, 4, 6, 8, 7]

  dummyPath = (el) -> pel.label for pel in (path el, parent)
  paths = _.fromPairs([el.label, dummyPath el] for el in bfsOrder)
  expect(paths).toMatchObject(
    4: [4, 3, 1]
    5: [5, 3, 1]
    6: [6, 3, 1]
    7: [7, 6, 3, 1]
    8: [8, 4, 3, 1])

    # elPath = path el, parent
    # console.log JSON.stringify elPath
    # # expect(elPath).toBe 5
