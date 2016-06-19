//= require draggabilly.min
$(document).ready ->
  window.automodeTimer = ""
  autoplaySwitch $.cookie("autoplay")
  getLiveStreams()
  updateChannel()
  setInterval (->
    getLiveStreams()
    updateChannel()
    return
  ), 30000
  $draggable = $('.draggable').draggabilly()
  return

@turnInterval = () ->
  return setInterval (->
    checkAuto()
    return
  ), 30000

@checkAuto = () ->
  if $("#livestatus").text() == "DEAD"
    $.get('/channel/live', (data) ->
      if data.error != true
        changeChannel(data.channels[0].service+'/'+data.channels[0].channel)
    )
  return

@updateChannel = ->
  $.get('channel/'+$("#stream").data("channelservice")+'/'+$("#stream").data("channelname"), (data) ->
    if data.error != true
      $("#viewercount").text(data.channel.viewers)
      $("#streamtitle").text(data.channel.streamer + ' - ' + data.channel.game)
      $("#livestatus").text(if data.channel.live then "LIVE" else "DEAD")
  )
  return

@getLiveStreams = ->
  channels = []
  lives = []
  $('#hdgameslive').text('')
  $('#hdkincolive').text('')
  clearChannelMenu()
  $.get('/channel/live', (data) ->
    for ch in data.channels
      if ch.service == "hd"
        $('#'+ch.channel+'live').text('LIVE')
      else if ch.service == "twitch"
        lives.push ch.service + '/' + ch.channel
        channels.push ch
    addChannels(channels)
  )
  return

@addChannels = (channels) ->
  for ch in channels
    $("#channelmenu").append('<li><a data-channelservice='+ch.service+' data-channelname='+ch.channel+' href="#/channel/'+ch.service+'/'+ch.channel+'" onclick="changeChannel(\''+ch.service+'/'+ch.channel+'\')"> '+ch.streamer+' </a></li>')
  return

@changeChannel = (ch) ->
  service = ch.split('/')[0]
  channel = ch.split('/')[1]
  $.get('channel/'+service+'/'+channel, (data) ->
    if data.error != true
      $("#stream").attr('src', data.channel.player)
      $("#stream").data('channelname', data.channel.channel)
      $("#stream").data('channelservice', data.channel.service)
      $("#streamlink").attr('href', data.channel.url).text(data.channel.url)
      $("#viewercount").text(data.channel.viewers)
      $("#streamtitle").text(data.channel.streamer + ' - ' + data.channel.game)
      $("#livestatus").text(if data.channel.live then "LIVE" else "DEAD")
  )
  return

@autoplaySwitch = (mode) ->
  $.cookie("autoplay", "off") if $.cookie("autoplay") is undefined

  if mode == null
    mode = $.cookie("autoplay")
    $("#autoplaybtn").text('Autoplay is '+ mode)
    window.automodeTimer = turnInterval() if mode == "on"
    $("#autoplaybtn").attr("onclick", "autoplaySwitch('off')") if mode == "on"
    $("#autoplaybtn").attr("onclick", "autoplaySwitch('on')") if mode == "off"
  else if mode == "on" and $.cookie("autoplay") == "off"
    $.cookie("autoplay", "on")
    window.automodeTimer = turnInterval()
    $("#autoplaybtn").text('Autoplay is '+ mode).attr("onclick", "autoplaySwitch('off')")
  else if mode == "off" and $.cookie("autoplay") == "on"
    $.cookie("autoplay", "off")
    clearInterval(window.automodeTimer)
    $("#autoplaybtn").text('Autoplay is '+ mode).attr("onclick", "autoplaySwitch('on')")
  return

@clearChannelMenu = () ->
  $("#channelmenu").each ->
    $(this).find("li").each ->
      $(this).find("a").each ->
        $(this).remove()
 return
