_ = require 'lodash'

module.exports.creepDesign =
  versatileWorker: (energyAvailable, opts) ->
    maxRepeat([WORK, CARRY, MOVE], energyAvailable, opts)
  courier: (energyAvailable, opts) -> maxRepeat([CARRY, MOVE], energyAvailable, opts)
  slowCourier: (energyAvailable, opts) ->
    opts.maxPower = Math.ceil(opts.maxPower/2) if opts.maxPower? # since we multiply it twice...
    opts.minPower = Math.ceil(opts.minPower/2) if opts.minPower?
    return maxRepeat([CARRY, CARRY, MOVE], energyAvailable, opts)
  observer: (energyAvailable, opts) -> [MOVE] if energyAvailable >= BODYPART_COST[MOVE]
  claimer: (energyAvailable, opts) -> if energyAvailable >= BODYPART_COST[MOVE] + BODYPART_COST[CLAIM] then [MOVE, CLAIM] else []
  optimizedWorker: (energyAvailable, opts) ->
    opts = _.defaults opts, {minPower: 1, maxPower: 50}
    return _.last _.filter((optimizedWorkerOfPower(n) for n in [opts.minPower..opts.maxPower]), (v) -> bodyPlanCost(v) <= energyAvailable and v.length <= 50)
  optimizedMiner: (energyAvailable, opts) ->
    opts = _.defaults opts, {minPower: 1, maxPower: 50}
    return _.last _.filter((optimizedWorkerOfPower(n, true) for n in [opts.minPower..opts.maxPower]), (v) -> bodyPlanCost(v) <= energyAvailable and v.length <= 50)

module.exports.bodyPlanCost = bodyPlanCost = (bodyPlan) ->
  _.sum(BODYPART_COST[type] for type in bodyPlan)

maxRepeat = (basicBodyPlan, energyAvailable, opts = {}) ->
  opts = _.defaults opts, {minPower: 1, maxPower: 50}
  throw new Error("invalid energy #{energyAvailable} or max power #{opts.maxPower}.") unless 0 <= energyAvailable and 1 <= opts.minPower <= opts.maxPower
  power = Math.min opts.maxPower, (Math.floor 50 / basicBodyPlan.length), (Math.floor (energyAvailable / bodyPlanCost(basicBodyPlan)))
  return _bodyRepeat(basicBodyPlan, power) if power >= opts.minPower

_bodyRepeat = (body, n) ->
  _.flatten ((part for [1..n]) for part in body)

optimizedWorkerOfPower = (n, ignoreCarry = false, k = 3) ->
  ncarry = if ignoreCarry then 1 else Math.ceil(n / k)
  nmove = Math.ceil((n + (if ignoreCarry then 0 else ncarry)) / 2)
  bodyPlan = [(_.fill Array(n), WORK)..., (_.fill Array(ncarry), CARRY)..., (_.fill Array(nmove), MOVE)...]
  # log.debug "power #{n} results in creep #{bodyPlan}"
  return bodyPlan
