redis = require 'redis'
EventEmitter = require("events").EventEmitter

module.exports = class PubsubStream extends EventEmitter
  constructor: () ->
    @_subscribe_client = redis.createClient.apply redis, arguments
    @_query_client = redis.createClient.apply redis, arguments

    @_subscribe_client.psubscribe "*"
    @_subscribe_client.on "pmessage", @_handlePmessage.bind this
  
  _handlePmessage: (pattern, channel, message) ->
    return if channel == "logstash"
    @_query_client.pubsub "NUMSUB", channel, (err, [_, subCount]) =>
      @emit "message", {subCount, channel, message}

  close: () ->
    @_subscribe_client.close()
    @_query_client.close()
