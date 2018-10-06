{creepDesign, bodyPlanCost} = require 'tools.body'
{expectJSON} = require 'util/compare.images'

generateAll = (energyAvailable) ->
  bodies = {}
  for k, fun of creepDesign
    bodies[k] = fun energyAvailable, {}
  return bodies

tryAll = (energyAvailable, jsonFileName) ->
  bodies = generateAll energyAvailable
  for k, body of bodies
    expect(bodyPlanCost body).toBeLessThanOrEqual energyAvailable

  expectJSON 'tools.body', jsonFileName, bodies, mode: 'assert'

test 'create small creeps body plan', ->
  tryAll 200, "smallBody"

test 'create medium creeps body plan', ->
  tryAll 700, "mediumBody"

test 'create large creeps body plan', ->
  tryAll 2500, "largeBody"

test 'verify max body size of 50 is enforced for any designer', ->
  unlimitedEnergyBodies = generateAll 10000
  for t, body of unlimitedEnergyBodies
    if body.length > 50 then throw new Error "#{t}, #{body.length}, #{JSON.stringify body}"
    expect(body.length).toBeLessThanOrEqual 50
  expectJSON 'tools.body', "unlimitedEnergyBodies", unlimitedEnergyBodies, mode: 'generate'
