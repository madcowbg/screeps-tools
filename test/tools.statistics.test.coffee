_ = require 'lodash'

statistics = require 'tools.statistics'

beforeEach =>
  Memory.stats = {}

test "logging some stats", ->
  statistics.root("some root").sub("inside")
    .write "stat1", "val1"
    .write "stat2", 2
    .write "stat3", undefined

  expect(Memory.stats).toEqual {
    "#{Game.time}":
      "some root":
        "inside":
          "stat1": "val1"
          "stat2": 2
          "stat3": undefined
  }
