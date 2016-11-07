path         = require('path')
childProcess = require('child_process')
phantomjs    = require('phantomjs-prebuilt')
crypto       = require("crypto")

class ChartImage

  constructor: () ->
    @binPath    = phantomjs.path
    @scriptFile = path.join(__dirname, './phantomjs-script.coffee')
    @width      = 960
    @height     = 540

  hash: (str) ->
    sha256 = crypto.createHash("sha256")
    sha256.update(str, "utf8")
    sha256.digest("hex")

  size: (width, height) ->
    @width  = width
    @height = height
    return @

  generate: (type, data, callback) ->
    tmp_dir = path.join(__dirname, '..', 'tmp')
    @filename  = "#{type}-#{@hash(data)}.png"
    @childArgs = [
      @scriptFile
      "#{tmp_dir}/#{@filename}"
      @width
      @height
      type
      data
    ]
    childProcess.execFile @binPath, @childArgs, callback

module.exports = ChartImage
