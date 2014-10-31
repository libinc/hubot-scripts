path         = require('path')
childProcess = require('child_process')
phantomjs    = require('phantomjs')
crypto       = require("crypto")

class ChartImage

  constructor: () ->
    @binPath    = phantomjs.path
    @scriptFile = path.join(__dirname, './phantomjs-script.coffee')

  hash: (str) ->
    sha256 = crypto.createHash("sha256")
    sha256.update(str, "utf8")
    sha256.digest("hex")

  generate: (type, data, callback) ->
    tmp_dir = path.join(__dirname, '..', 'tmp')
    @filename  = "#{type}-#{@hash(data)}.png"
    @childArgs = [
      @scriptFile
      "#{tmp_dir}/#{@filename}"
      type
      data
    ]
    childProcess.execFile @binPath, @childArgs, callback

module.exports = ChartImage
