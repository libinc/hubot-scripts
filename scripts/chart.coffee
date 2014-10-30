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

path = require('path')
childProcess = require('child_process')
phantomjs = require('phantomjs')
binPath = phantomjs.path

childArgs = [path.join(__dirname, '../module/phantomjs-script.coffee')]

module.exports = (robot) ->

  robot.respond /chart/i, (msg) ->
    childProcess.execFile binPath, childArgs, (err, stdout, stderr) ->
      msg.send "OK"

