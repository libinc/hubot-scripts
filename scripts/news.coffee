# Description:
#   Get your favorite news
#
# Dependencies:
#   "cheerio": "0.17.0"
#
# Commands:
#   hubot news hatebu <category> -- List hot entries on Hatena bookmarks
#
# Author:
#   yulii

cheerio = require('cheerio')

module.exports = (robot) ->
  robot.respond /news\s+hatebu(\s+\w+)?/i, (msg) ->
    type = (msg.match[1] || "").trim()
    url  = "http://b.hatena.ne.jp/hotentry/#{type}"
    viewList msg, url

viewList = (msg, url) ->
  msg.send "GET #{url}", "Please wait a few seconds."
  msg.http("#{url}.rss")
    .get() (err, res, body) ->
      if res.statusCode isnt 200
        msg.send "Request didn't come back HTTP 200 :("
        return

      $ = cheerio.load(body, normalizeWhitespace: true, xmlMode: true)
      $('item').each (i, e) ->
        title = $(this).find('title').text()
        link  = $(this).find('link').text()
        msg.send "#{title}\n#{link}"

