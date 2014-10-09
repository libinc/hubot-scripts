# Description:
#   Github management tools
#
# Dependencies:
#   "githubot": "0.4.x"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_API
#   HUBOT_GITHUB_REPOS_PATH
#
# Commands:
#   hubot github show:issue <options> -- List issues for a repository
#   hubot github create:issue <options> -- Create a issue for a repository
#
# Notes:
#   HUBOT_GITHUB_API allows you to set a custom URL path (for Github enterprise users)
#
#   Options format exsample:
#     hubot github create:issue title:issue-title body:awesome repo:owner/repo_name
#
# Author:
#   yulii

class CommandOption

  constructor: (@args) ->
    self = this
    @params = {}
    for field in @args.split(/\s+/)
      o = self.parse(field)
      @params[o.label] = o.value

  parse: (field) ->
    separatorIndex = field.indexOf(':');
    l = field.slice(0, separatorIndex)
    v = field.slice(separatorIndex + 1)
    v = v.split(',') if v.indexOf(',') >= 0
    { label: l, value: v } 

  data: () ->
    args = Array.prototype.slice.call(arguments)
    data = {}
    for key of @params
      data[key] = @params[key] if args.indexOf(key) >= 0
    return data

  query: () ->
    args = Array.prototype.slice.call(arguments)
    list = []
    for key of @params
      list.push("#{key}=#{@params[key]}") if args.indexOf(key) >= 0
    return list.join("&")

  get: (name) ->
    @params[name]


module.exports = (robot) ->

  github = require("githubot")(robot)

  unless (url_api_base = process.env.HUBOT_GITHUB_API)?
    url_api_base = "https://api.github.com"

  repos_path = process.env.HUBOT_GITHUB_REPOS_PATH

  signature = (name) ->
    "\n- Created by #{name} via Hubot"

  ## List issues for a repository
  robot.respond /github\s+show:issues?(\s+)?(.+)?/i, (msg) ->

    option    = new CommandOption(msg.match[2])
    repo_path = option.get('repo') ? repo_path

    unless repo_path?
      msg.send "No repository specified, please provide one or set HUBOT_GITHUB_REPOS_PATH accordingly."
      return

    url   = "#{url_api_base}/repos/#{repo_path}/issues"
    query = option.query('milestone', 'state', 'assignee', 'creator', 'mentioned', 'labels', 'sort', 'direction', 'since')

    github.get "#{url}?#{query}", (issues) ->
      if issues.length == 0
        summary = "Achievement unlocked: open issues zero!"
      else
        if issues.length == 1
          summary = "There's only one open issue for #{repo_path}:"
        else
          summary = "I found #{issues.length} open issues for #{repo_path}:"

        for issue in issues
          summary = summary + "\n\t#{issue.title} (#{if issue.assignee then issue.assignee.login else 'no assignee'}) -> #{issue.html_url}"

      msg.send summary

  ## Create an issue
  robot.respond /github\s+create:issue\s+(.+)/i, (msg) ->

    option    = new CommandOption(msg.match[1])
    repo_path = option.get('repo') ? repo_path

    unless repo_path?
      msg.send "No repository specified, please provide one or set HUBOT_GITHUB_REPOS_PATH accordingly."
      return

    url  = "#{url_api_base}/repos/#{repo_path}/issues"
    data = option.data('title', 'body', 'assignee', 'milestone', 'labels')

    data['body'] ?= ''
    data['body']  = signature(msg.message.user.name)

    github.post url, data, (issue) ->
      console.log(issue)
      msg.send "#{issue.title} (#{if issue.assignee then issue.assignee.login else 'no assignee'}) -> #{issue.html_url}"


