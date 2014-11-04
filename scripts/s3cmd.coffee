# Description:
#   Aamazon Web Service (S3)
#
# Dependencies:
#   "aws-sdk": "^2.0.23"
#   "sugar": "^1.4.1"
#
# Commands:
#   hubot s3cmd ls -- List all of your S3 buckets
#
# Notes:
#   Don't hard-code your credentials!
#   Export the following environment variables instead:
#
#   export AWS_ACCESS_KEY_ID='AKID'
#   export AWS_SECRET_ACCESS_KEY='SECRET'
#
# Author:
#   yulii
#
require('sugar')
URL = require('url')

AWS = require('aws-sdk')
AWS.config.region = process.env.AWS_REGION ? 'ap-northeast-1'
s3 = new AWS.S3()

module.exports = (robot) ->

  robot.respond /s3cmd\s+ls(\s+.+)?/i, (msg) ->
    if (arg = msg.match[1])
      url = URL.parse(arg)

      params =
        Bucket:    url.host
        Delimiter: "/"
        Prefix:    (url.pathname ? "/").slice(1)

      s3.listObjects params, (err, data) ->
        result = ''
        # List of prefixes (directories)
        for cp in data.CommonPrefixes
          result += "                    #{cp.Prefix}\n"

        for content in data.Contents
          modified = Date.create(content.LastModified).format("{Mon} {dd}, {yyyy} {hh}:{mm}")
          result += "#{modified}  #{content.Key}\n"
        msg.send result
        
    else # List of S3 buckets
      s3.listBuckets (err, data) ->
        result = ''
        for bucket in data.Buckets
          created = Date.create(bucket.CreationDate).format("{Mon} {dd}, {yyyy} {hh}:{mm}")
          result += "#{created}  #{bucket.Name}\n"
        msg.send result


