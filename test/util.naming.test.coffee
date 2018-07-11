_ = require 'lodash'
naming = require './utils.naming'

test 'generating creep name with undefined', () ->
  expect(() -> naming.genUniqueCreepName()).toThrow(TypeError)

tryAddingCreep = (creeps, prefix, suffix) ->
  name = naming.genUniqueCreepName(creeps, prefix, suffix)
  pf = if prefix? then prefix else ""
  sf = if suffix? then suffix else ""
  minLength = 3 + pf.length + sf.length
  expect(name.length).toBeGreaterThanOrEqual minLength
  expect(name).toMatch new RegExp "#{pf}.*#{sf}"
  expect(_.keys creeps).not.toContain name
  creeps[name] = true

test 'generating several creeps names', () ->
  creeps = {}
  tryAddingCreep creeps for i in [0...200]
  tryAddingCreep creeps, "ABC", "XYZ" for i in [0...20]
  return undefined

#TODO add tests for genUniqueCreepName
