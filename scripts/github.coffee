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
#   hubot search me issues <query> -- Searching issues (cf. https://help.github.com/articles/searching-issues/ )
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

  ## Searching issues
  robot.respond /search\s+(me\s+)?issues?\s+(.+)/i, (msg) ->

    query = require('querystring').escape(msg.match[2])

    github.get "#{url_api_base}/search/issues?q=#{query}&per_page=100", (result) ->
      if result.total_count == 0
        summary = "Not found!"
      else
        if result.total_count == 1
          summary = "There's only one issue:"
        else
          summary = "I found #{result.total_count} issues:"

        for issue in result.items
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


