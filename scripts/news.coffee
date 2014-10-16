# Description:
#   Get your favorite news
#
# Dependencies:
#   "cheerio": "0.17.0"
#
# Commands:
#   hubot news hatebu <category> -- List hot entries on Hatena bookmarks
#   hubot news jvn <options> -- List vulnerability reports on JVN
#
# Notes:
#   Options format exsample:
#     hubot news jvn level:m term:m
#
# Author:
#   yulii

Option  = require('../module/command_option')
cheerio = require('cheerio')

module.exports = (robot) ->

  jvn_api_url = "http://jvndb.jvn.jp/myjvn"

  robot.respond /news\s+jvn(\s+.+)?/i, (msg) ->
    option = new Option(msg.match[1])
    term   = option.get("term")
    level  = option.get("level")

    data =
      method: "getVulnOverviewList"
      rangeDatePublic: "n"
      rangeDateFirstPublished: "n"
      rangeDatePublished: term ? "w"
      severity: level ? "h"
      lang: "ja"

    msg.send "GET http://jvn.jp/\nPlease wait a few seconds."
    msg.http(jvn_api_url)
      .query(data)
      .get() (err, res, body) ->
        if res.statusCode isnt 200
          msg.send "Request didn't come back HTTP 200 :("
          return

        $ = cheerio.load(body, normalizeWhitespace: true, xmlMode: true)
        result = ""
        $("item").each (i, e) ->
          self = $(this)
          title    = self.find('title').text()
          link     = self.find('link').text()
          cvss     = self.find('sec\\:cvss')
          score    = cvss.attr('score')

          modified = new Date(self.find('dcterms\\:modified').text())

          msg.send "#{modified.toDateString()} [#{score}] #{title}\n#{link}"

  robot.respond /news\s+hatebu(\s+\w+)?/i, (msg) ->
    type = (msg.match[1] || "").trim()
    url  = "http://b.hatena.ne.jp/hotentry/#{type}"
    viewList msg, url

viewList = (msg, url) ->
  msg.send "GET #{url}\nPlease wait a few seconds."
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

