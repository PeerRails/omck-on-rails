$(document).ready ->
  if location.hostname == 'omck.moe'
    @hd = 'hd.omck.moe'
  else if location.hostname == 'omck.tv' || location.hostname == 'omck.ws'
    @hd = 'hd.omck.tv'
  else
    @hd = 'localhost'
  if location.pathname.split('/')[2] == 'hdgames' || location.pathname.split('/')[2] == 'hdkinco' || location.pathname.split('/')[2] == 'records'
    channel = location.pathname.split('/')[2]
  else
    channel = "records"
  if channel == "hdgames"
    channel = "live"
  else if channel == "hdkinco"
    channel = "cinema"
  console.log 'http://' + @hd + '/dash/' + channel + '/omcktv.mpd'
  conf =
    key: '4289ecc38c96d781a8aadf9941496941'
    source:
      mpd: 'http://' + @hd + '/dash/' + channel + '/omcktv.mpd'
      hls: 'http://' + @hd + '/hls/' + channel + '/omcktv.m3u8'
      poster: '/assets/bg/omck.jpg'
    playback:
      autoplay: true
      muted: false
    style:
      width: '100%'
      height: '100%'
    events:
      onError: (data) ->
        console.error 'bitdash error: ' + data.code + ': ' + data.message
        return
      onReady: (obj) ->
        console.log @getVersion() + ' onReady: ', obj
        return
  player = bitdash('video').setup(conf)
  return