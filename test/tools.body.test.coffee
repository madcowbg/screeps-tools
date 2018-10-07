{creepDesign, bodyPlanCost} = require 'tools.body'

generateAll = (energyAvailable) ->
  bodies = {}
  for k, fun of creepDesign
    bodies[k] = fun energyAvailable, {}
  return bodies

tryAll = (energyAvailable, expectedBodies) ->
  bodies = generateAll energyAvailable
  for k, body of bodies
    expect(bodyPlanCost body).toBeLessThanOrEqual energyAvailable

  expect(expectedBodies).toEqual(bodies)

test 'create small creeps body plan', ->
  tryAll 200, {
    "versatileWorker":["work","carry","move"],
    "courier":["carry","carry","move","move"],
    "slowCourier":["carry","carry","move"],
    "observer":["move"],
    "claimer":[],
    "optimizedWorker":["work","carry","move"],
    "optimizedMiner":["work","carry","move"]
  }

test 'create medium creeps body plan', ->
  tryAll 700, {
    "versatileWorker":["work","work","work","carry","carry","carry","move","move","move"],
    "courier":["carry","carry","carry","carry","carry","carry","carry","move","move","move","move","move","move","move"],
    "slowCourier":["carry","carry","carry","carry","carry","carry","carry","carry","move","move","move","move"],
    "observer":["move"],
    "claimer":["move","claim"],
    "optimizedWorker":["work","work","work","work","carry","carry","move","move","move"],
    "optimizedMiner":["work","work","work","work","work","carry","move","move","move"]
  }

test 'create large creeps body plan', ->
  tryAll 2500, {
    "versatileWorker":["work","work","work","work","work","work","work","work","work","work","work","work","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","move","move","move","move","move","move","move","move","move","move","move","move"],
    "courier":["carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move"],
    "slowCourier":["carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move"],
    "observer":["move"],
    "claimer":["move","claim"],
    "optimizedWorker":["work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","carry","carry","carry","carry","carry","carry","move","move","move","move","move","move","move","move","move","move","move"],
    "optimizedMiner":["work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","carry","move","move","move","move","move","move","move","move","move","move"]
  }

test 'verify max body size of 50 is enforced for any designer', ->
  unlimitedEnergyBodies = generateAll 10000
  for t, body of unlimitedEnergyBodies
    if body.length > 50 then throw new Error "#{t}, #{body.length}, #{JSON.stringify body}"
    expect(body.length).toBeLessThanOrEqual 50

  expect(unlimitedEnergyBodies).toEqual {
    "versatileWorker":["work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move"],
    "courier":["carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move"],
    "slowCourier":["carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","carry","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move"],
    "observer":["move"],
    "claimer":["move","claim"],
    "optimizedWorker":["work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","carry","carry","carry","carry","carry","carry","carry","carry","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move"],
    "optimizedMiner":["work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","work","carry","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move","move"]
  }
