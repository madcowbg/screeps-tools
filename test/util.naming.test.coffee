global.Game = {}
global.Memory = {}

_ = require 'lodash'
naming = require './utils.naming'

test 'generating creep name with undefined', () ->
  expect(() -> naming.genUniqueCreepName()).toBeDefined()

mockupCreep = (name) ->
  return {name: name}

testAddingNewCreep = (prefix, suffix) ->
  name = naming.genUniqueCreepName(prefix, suffix)
  pf = if prefix? then prefix else ""
  sf = if suffix? then suffix else ""
  minLength = 3 + pf.length + sf.length
  expect(name.length).toBeGreaterThanOrEqual minLength
  expect(name).toMatch new RegExp "#{pf}.*#{sf}"
  expect(_.keys Game.creeps).not.toContain name
  Game.creeps[name] = mockupCreep(name) # Fixme use actual creep

test 'generating several creeps names', () ->
  Game.creeps = {}  # reset set of creeps
  testAddingNewCreep() for i in [0...200]
  testAddingNewCreep("ABC", "XYZ") for i in [0...20]
  return undefined

#TODO add tests for genUniqueCreepName
