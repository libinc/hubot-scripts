path         = require('path')
childProcess = require('child_process')
phantomjs    = require('phantomjs')

class ChartImage

  constructor: () ->
    @binPath    = phantomjs.path
    @scriptFile = path.join(__dirname, './phantomjs-script.coffee')
    #@scriptFile = __filename
    @filename   = 'chartjs'

  generate: (type, data, callback) ->
    @childArgs = [
      @scriptFile
      @filename
      type
      data
    ]
    childProcess.execFile @binPath, @childArgs, callback

  #callback: (err, stdout, stderr) ->


module.exports = ChartImage
