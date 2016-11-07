# Description:
#   Generate a chart image
#
# Commands:
#   hubot chart <type> <data> -- Generate a chart image (cf. Chart.js)
#
# Author:
#   yulii

# fs   = require('fs')
# path = require('path')
# ChartImage = require('../module/chart_image')
#
# module.exports = (robot) ->
#
#   robot.helper =
#     url: () ->
#       server = robot.server.address()
#       process.env.HEROKU_URL ? "http://#{server.address}:#{server.port}"
#
#   #hubot_url = () ->
#   #  server = robot.server.address()
#   #  process.env.HEROKU_URL ? "http://#{server.address}:#{server.port}"
#
#   robot.respond /chart\s+(\w+)\s+(.+)/i, (msg) ->
#     type = msg.match[1]
#     data = msg.match[2]
#
#     msg.send "Please wait a few seconds. Now creating..."
#     chart = new ChartImage()
#     chart.generate type, data, (err, stdout, stderr) ->
#       if err
#         msg.send "#{err.name}: #{err.message}"
#       filename = encodeURIComponent(chart.filename)
#       msg.send "#{robot.helper.url()}/hubot/charts/#{filename}"
#
#   ## Get an image from `/tmp` dir
#   robot.router.get "/hubot/charts/:key", (req, res) ->
#     tmp = path.join(__dirname, '..', 'tmp', req.params.key)
#     fs.exists tmp, (exists) ->
#       if exists
#         fs.readFile tmp,(err,data) ->
#           res.writeHead(200, { 'Content-Type': 'image/png' })
#           res.end(data)
#       else
#         res.status(404).send('Not found')
#
