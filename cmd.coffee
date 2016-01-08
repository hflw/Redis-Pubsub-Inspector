PubsubStream = require './pubsub-stream'

pad = (str, count) ->
  str = str+""
  while(str.length < count)
    str += " "
  return str

stream = new PubsubStream()
stream.on 'message', (e) ->
  console.log "-- #{pad(e.subCount, 4)} #{e.channel}"
  console.log "   #{e.message}"
