_ = require 'lodash'
log = require 'tools.log'

test "logging has defined required functions", ->
  mandatoryFuns = ["important", "warn", "error", "debug", "trace", "assert"]
  expect(_.keys log).toMatchObject mandatoryFuns

  for funKey in mandatoryFuns
    expect(typeof log[funKey]).toBe "function"

  unless typeof log["info"] == "function" or log["info"] == undefined
    throw new Error "invalid log.info: #{log["info"]}"

  return

test "logging functions do call console.log with proper arguments", ->
  backupLog = console.log
  logFuns = ["important", "warn", "error", "debug", "trace", "info"]

  try
    msg = "LALALALA LA BAMBA"
    for funKey in logFuns when log[funKey]?
      console.log = jest.fn()
      log[funKey](msg)

      expect(console.log).toHaveBeenCalledTimes 1

      lastCallArgs = _.last console.log.mock.calls
      expect(lastCallArgs.join " ").toMatch(new RegExp("#{msg}"))
  finally
    console.log = backupLog
  return
