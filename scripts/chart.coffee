# Description:
#   Chart
#
# Dependencies:
#   "chart.js": "^1.0.1-beta.2"
#   "phantomjs": "^1.9.12"
#
# Commands:
#   hubot news hatebu <category> -- List hot entries on Hatena bookmarks
#   hubot news jvn <options> -- List vulnerability reports on JVN
#
# Author:
#   yulii

ChartImage  = require('../module/chart_image')

#path = require('path')
#childProcess = require('child_process')
#phantomjs = require('phantomjs')
#binPath = phantomjs.path
#
#childArgs = [
#  path.join(__dirname, '../module/phantomjs-script.coffee')
#  'chartjs'
#  'pie'
#  '[{ "value": 55 }, { "value": 45 }]'
#]

module.exports = (robot) ->

  robot.respond /chart/i, (msg) ->
    chart = new ChartImage()
    #chart.callback (err, stdout, stderr) ->
    #  console.log("OK")
    #  if err
    #    msg.send "#{err.name}: #{err.message}"
    #  msg.send "OK"
    dataStr = '[{ "value": 75, "color":"#FFCCCC"}, { "value": 25, "color":"#CCCCFF"}]'

    chart.generate 'pie', dataStr, (err, stdout, stderr) ->
      if err
        msg.send "#{err.name}: #{err.message}"
      msg.send "OK"


    #childProcess.execFile binPath, childArgs, (err, stdout, stderr) ->
    #  if err
    #    msg.send "#{err.name}: #{err.message}"
    #  msg.send "OK"

