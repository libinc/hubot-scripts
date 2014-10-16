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
#   hubot github show:issues <options> -- List issues for a repository
#   hubot github show:pulls <options> -- List pull requests for a repository
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

Option  = require('../module/command_option')

module.exports = (robot) ->

  github = require("githubot")(robot)

  unless (url_api_base = process.env.HUBOT_GITHUB_API)?
    url_api_base = "https://api.github.com"

  repos_path = process.env.HUBOT_GITHUB_REPOS_PATH

  signature = (name) ->
    "\n- Created by #{name} via Hubot"

  ## List issues for a repository
  robot.respond /github\s+show:issues?(\s+.+)?/i, (msg) ->

    option    = new Option(msg.match[1])
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

  ## List issues for a repository
  robot.respond /github\s+show:pulls?(\s+.+)?/i, (msg) ->

    option    = new Option(msg.match[1])
    repo_path = option.get('repo') ? repo_path

    unless repo_path?
      msg.send "No repository specified, please provide one or set HUBOT_GITHUB_REPOS_PATH accordingly."
      return

    url   = "#{url_api_base}/repos/#{repo_path}/pulls"
    query = option.query('state', 'head', 'base', 'sort', 'direction')

    github.get "#{url}?#{query}", (issues) ->
      if issues.length == 0
        summary = "Achievement unlocked: open pull requests zero!"
      else
        if issues.length == 1
          summary = "There's only one open pull request for #{repo_path}:"
        else
          summary = "I found #{issues.length} open pull requests for #{repo_path}:"

        for issue in issues
          summary = summary + "\n\t#{issue.title} (#{if issue.assignee then issue.assignee.login else 'no assignee'}) -> #{issue.html_url}"

      msg.send summary

  ## Create an issue
  robot.respond /github\s+create:issue\s+(.+)/i, (msg) ->

    option    = new Option(msg.match[1])
    repo_path = option.get('repo') ? repo_path

    unless repo_path?
      msg.send "No repository specified, please provide one or set HUBOT_GITHUB_REPOS_PATH accordingly."
      return

    url  = "#{url_api_base}/repos/#{repo_path}/issues"
    data = option.data('title', 'body', 'assignee', 'milestone', 'labels')

    data['body'] ?= ''
    data['body']  = signature(msg.message.user.name)

    github.post url, data, (issue) ->
      msg.send "#{issue.title} (#{if issue.assignee then issue.assignee.login else 'no assignee'}) -> #{issue.html_url}"


