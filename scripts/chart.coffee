# Description:
#   Generate a chart image
#
# Dependencies:
#   "chart.js": "^1.0.1-beta.2"
#   "phantomjs": "^1.9.12"
#
# Commands:
#   hubot chart <type> <data> -- Generate a chart image
#
# Author:
#   yulii

fs   = require('fs')
path = require('path')
ChartImage = require('../module/chart_image')

module.exports = (robot) ->

  robot.respond /chart\s+(\w+)\s+(.+)/i, (msg) ->
    type = msg.match[1]
    data = msg.match[2]

    chart = new ChartImage()
    chart.generate type, data, (err, stdout, stderr) ->
      if err
        msg.send "#{err.name}: #{err.message}"
      msg.send "OK"

  ## Get an image from `/tmp` dir
  robot.router.get "/hubot/charts/:key", (req, res) ->
    tmp = path.join(__dirname, '..', 'tmp', req.params.key)
    path.exists tmp, (exists) ->
      if exists
        fs.readFile tmp,(err,data) ->
          res.writeHead(200, { 'Content-Type': 'image/png' })
          res.end(data)
      else
        res.status(404).send('Not found')

