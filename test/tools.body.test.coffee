{creepDesign, bodyPlanCost} = require 'tools.body'
{expectJSON} = require 'util/compare.images'

tryAll = (energyAvailable) ->
  bodies = {}
  for k, fun of creepDesign
    bodies[k] = fun energyAvailable, {}
  return bodies

test 'create small creeps body plan', ->
  smallBody = tryAll 200
  for t, body of smallBody
    expect(bodyPlanCost body).toBeLessThanOrEqual 200
  expectJSON 'tools.body', "smallBody", smallBody, mode: 'assert'

test 'create medium creeps body plan', ->
  mediumBody = tryAll 700
  for t, body of mediumBody
    expect(bodyPlanCost body).toBeLessThanOrEqual 700
  expectJSON 'tools.body', "mediumBody", mediumBody, mode: 'assert'

test 'create large creeps body plan', ->
  largeBody = tryAll 2500
  for t, body of largeBody
    expect(bodyPlanCost body).toBeLessThanOrEqual 2500
  expectJSON 'tools.body', "largeBody", largeBody, mode: 'assert'
