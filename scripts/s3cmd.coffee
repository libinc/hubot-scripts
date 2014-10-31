# Description:
#   Aamazon Web Service (S3)
#
# Dependencies:
#   "aws-sdk": "^2.0.23"
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
AWS = require('aws-sdk');
AWS.config.region = process.env.AWS_REGION ? 'ap-northeast-1'
s3 = new AWS.S3()

module.exports = (robot) ->

  robot.respond /s3cmd\s+ls/i, (msg) ->
    s3.listBuckets (err, data) ->
      result = ''
      for bucket in data.Buckets
        result += "#{bucket.CreationDate} s3://#{bucket.Name}\n"
      msg.send result

