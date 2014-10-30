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

ChartImage  = require('../module/chart_image')

module.exports = (robot) ->

  robot.respond /chart\s+(\w+)\s+(.+)/i, (msg) ->
    type = msg.match[1]
    data = msg.match[2]

    chart = new ChartImage()
    chart.generate type, data, (err, stdout, stderr) ->
      if err
        msg.send "#{err.name}: #{err.message}"
      msg.send "OK"

