# Description:
#   A simple interaction with the built in HTTP Daemon
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# URLS:
#   /hubot/log/:room
#
# Author:
#   yulii

module.exports = (robot) ->

  ## Notify a log message
  robot.router.post "/hubot/log/:room", (req, res) ->
    user = room: "##{req.params.room}"
    console.log(req.body)
    data = req.body
    message = "[#{data.level.toUpperCase()}] #{data.message}"
    if /FATAL/i.test(data.level) or /ERROR/i.test(data.level)
      message += " @channel"

    robot.send user, message
    res.end "OK\n"

