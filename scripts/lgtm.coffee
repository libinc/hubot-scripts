# Description:
#   LGTM!
#
# Commands:
#   hubot reply <query> -- Respond an image from tiqav.com
#
# Author:
#   yulii

cheerio = require('cheerio')

module.exports = (robot) ->

  # Looks good to me!
  robot.respond /lgtm/i, (msg) ->
    robot.http("http://www.lgtm.in/g")
      .get() (err, res, body) ->
        if res.statusCode is 302
          robot.http(res.headers.location, { rejectUnauthorized: false })
            .get() (err, res, body) ->
              $ = cheerio.load(body)
              msg.send $('#imageUrl').attr('value')

  # GET an image from tiqav
  robot.respond /reply\s+(.+)?/i, (msg) ->
    robot.http("http://api.tiqav.com/search/random.json")
      .query(q: msg.match[1])
      .get() (err, res, body) ->
        if err
          msg.send "tiqav says: #{err}"
          return

        content = JSON.parse(body)
        size    = content.length
        if size <= 0
          msg.send "http://tiqav.com/Hi.th.jpg\n*Image NOT Found*"
        else
          select  = (new Date().getTime()) % size
          image   = content[select]
          msg.send "http://tiqav.com/#{image.id}.#{image.ext}"

