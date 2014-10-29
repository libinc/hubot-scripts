# Description:
#   Chart
#
# Dependencies:
#   "chart.js": "^1.0.1-beta.2"
#   "jquery": "^2.1.1"
#   "phantomjs": "^1.9.12"
#
# Commands:
#   hubot news hatebu <category> -- List hot entries on Hatena bookmarks
#   hubot news jvn <options> -- List vulnerability reports on JVN
#
# Author:
#   yulii

$ = require('jquery')

path = require('path')
childProcess = require('child_process')
phantomjs = require('phantomjs')
binPath = phantomjs.path

childArgs = [path.join(__dirname, '../module/phantomjs-script.js')]

module.exports = (robot) ->
  #page = require('webpage').create()
  #Chart = require('chart.js/Chart')

  robot.respond /chart/i, (msg) ->
    childProcess.execFile binPath, childArgs, (err, stdout, stderr) ->
      msg.send "OK"

    #phantom.create (ph) ->
    #  ph.createPage (page) ->
    #    page.evaluate () ->
    #      canvas = $('<canvas />').attr(width: 600, height: 480).appendTo($('body'))
    #      ph.exit()
    #      msg.send "OK"
        #page.open "http://www.google.com", (status) ->
        #  console.log "opened google? ", status
        #  page.evaluate (-> document.title), (result) ->
        #    console.log 'Page title is ' + result
        #    ph.exit()

    #page.evaluate () ->
    #  #canvas = $('<canvas />').attr(width: 600, height: 480).appendTo($('body'))
    #  msg.send "OK"

