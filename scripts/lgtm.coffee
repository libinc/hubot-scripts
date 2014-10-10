# Description:
#   LGTM!
#
# Dependencies:
#   "cheerio": "0.17.0"
#
# Author:
#   yulii

cheerio = require('cheerio')

module.exports = (robot) ->
  robot.hear /lgtm/i, (msg) ->
    msg.http("http://www.lgtm.in/g")
      .get() (err, res, body) ->
        $ = cheerio.load(body)
        msg.send $('#imageUrl').attr('value')
