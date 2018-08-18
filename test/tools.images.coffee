fs = require 'fs-extra-promise'
Rembrandt = require 'rembrandt'

dumpImageFiles = (pathToTestImages, result, imgName, imgBuffer) ->
  newImageFilename = pathToTestImages + "#{imgName}.new.png"
  diffImageFilename = pathToTestImages + "#{imgName}.diff.png"
  if result.passed
    fs.unlinkSync newImageFilename if fs.existsSync newImageFilename
    fs.unlinkSync diffImageFilename if fs.existsSync diffImageFilename
  else
    fs.writeFileSync newImageFilename, imgBuffer
    fs.writeFileSync diffImageFilename, result.compositionImage


module.exports.expectImageAsync = (imgName, imgBuffer) ->
  pathToTestImages = "test/imgs/"
  origImageFileName = pathToTestImages + "#{imgName}.png"
  unless fs.existsSync origImageFileName
    fs.writeFileSync pathToTestImages + "#{imgName}.new.png", imgBuffer
    throw new Error "original test image #{origImageFileName} does not exist!"

  rembrandt = new Rembrandt {
     imageA: origImageFileName
     imageB: imgBuffer
     renderComposition: true
     thresholdType: Rembrandt.THRESHOLD_PIXELS
     maxThreshold: 20
  }

  result = await rembrandt.compare()

  dumpImageFiles pathToTestImages, result, imgName, imgBuffer

  expect(result.passed).toBe true
