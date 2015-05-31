//=require jwplayer
//=require jwplayer.html5

@ls_omck = '<object type="application/x-shockwave-flash" data="https://cdn.livestream.com/grid/LSPlayer.swf?channel=mc_mc_mc_omck&amp;color=0xe7e7e7&amp;autoPlay=true&amp;mute=false" height="100%" width="100%"><param name="movie" value="https://cdn.livestream.com/grid/LSPlayer.swf?channel=mc_mc_mc_omck&amp;color=0xe7e7e7&amp;autoPlay=true&amp;mute=false"><param name="wmode" value="transparent"><param name="allowFullscreen" value="true"></object>'
@hd_omck = "<div id=\"mediaspace\"></div>"
@tw_omck = "<object type=\"application/x-shockwave-flash\" height=\"100%\" width=\"100%\" id=\"live_embed_player_flash\" data=\"http://www.twitch.tv/widgets/live_embed_player.swf?channel=omcktv\" bgcolor=\"#000000\"><param name=\"allowFullScreen\" value=\"true\" /><param name=\"allowScriptAccess\" value=\"always\" /><param name=\"allowNetworking\" value=\"all\" /><param name=\"movie\" value=\"http://www.twitch.tv/widgets/live_embed_player.swf\" /><param name=\"wmode\" value=\"transparent\"><param name=\"flashvars\" value=\"hostname=www.twitch.tv&channel=omcktv&auto_play=true&start_volume=100\" /></object>"
@current_channel = "livestream/mc_mc_mc_omck"


@MakeStreamMenu = ->
  $.getJSON "/channel/live", (list) ->
    menu_list = []
    live_list = []
    official = ["mc_mc_mc_omck","hdgames","hdkinco","omcktv"]
    $("ul#stream-menu a").each (i) ->
      menu_list.push $(this).attr("id") unless typeof ($(this).attr("id")) is "undefined"
      return
    list.map (chan) ->
      live_list.push chan.channel
    #console.log "Menu List: " + menu_list
    #console.log "Live List: " + live_list
    if list.length is 0
      $("#stream-count").html ""
      menu_list.map (li) ->
        DeleteChannelFromMenu li unless li in official
        ChangeMenuChannel li, "", 0, "" unless li not in official
    else
      $("#stream-count").html list.length
      list.map (chan) ->
        if chan.channel in official
          ChangeMenuChannel chan.channel, "LIVE", chan.viewers, chan.streamer
        else if chan.channel not in menu_list
          AddMenuChannel chan.channel, chan.service, chan.streamer, "LIVE", chan.viewers, chan.title
      if menu_list.length != 0
        menu_list.map (chan) ->
          if (chan not in live_list) and (chan not in official)
            DeleteChannelFromMenu chan
          if (chan not in live_list) and (chan in official)
            ChangeMenuChannel chan, "", 0, ""





#@NullOfficial = (channel) ->

@ChangeMenuChannel = (channel, live, viewers, title) ->
  $("#live-"+channel).html(live)
  $("#viewers-"+channel).html(viewers)
  $("#title-"+channel).html title

@AddMenuChannel = (channel, service, streamer, live, viewers, title) ->

  new_channel = '<a href="#/channel/'+service+'/'+channel+'" class="list-group-item" id="'+channel+'" onclick="SelectStream(\''+service+'/'+channel+'\');">'+
                '<span class="badge pull-right">'+
                '<i class="fa fa-eye" id="viewers-'+channel+'">'+viewers+'</i>'+
                '</span>'+
                streamer+
                '<span class="label label-danger pull-right" id="live-'+channel+'"> '+live+'</span>'+
                '<p id="title-'+channel+'">'+
                title+
                '</p>'+
                '</a>';
  $("ul#stream-menu").append new_channel

@DeleteChannelFromMenu = (channel) ->
  $("a#"+channel).remove()

@UpdateChannel = ->
  channel = @current_channel.split("/")
  $.getJSON "/channel/"+channel[0]+"/"+channel[1], (data) ->
    $("button#viewers").html "Viewers: " + data.viewers

#@GetChannel = (channel) ->

@InsertHD = (omck) ->
  $("#stream").html('<div id="streamjs"></div>').promise().done( ->
              jwplayer('stream').setup
                playlist: [ {
                  image: '/assets/bg/omck.jpg'
                  sources: [
                    { file: 'rtmp://hd.omck.moe/'+omck+'/omcktv' }
                    { file: 'http://hd.omck.moe/hls/'+omck+'/omcktv.m3u8' }
                  ]
                } ]
                primary: 'flash'
                width: '100%'
                height: '100%'
                autostart: true
              )

@SelectStream = (channel_service) ->
  split_input = channel_service.split('/')
  channel = split_input[1]
  service = split_input[0]
  $.getJSON "/channel/"+service+"/"+channel, (data) ->
    switch data.service
      when "livestream"
        ls_omck = '<object type="application/x-shockwave-flash" data="https://cdn.livestream.com/grid/LSPlayer.swf?channel=mc_mc_mc_omck&amp;color=0xe7e7e7&amp;autoPlay=true&amp;mute=false" height="100%" width="100%"><param name="movie" value="https://cdn.livestream.com/grid/LSPlayer.swf?channel=mc_mc_mc_omck&amp;color=0xe7e7e7&amp;autoPlay=true&amp;mute=false"><param name="wmode" value="transparent"><param name="allowFullscreen" value="true"></object>'
        $("#stream").html(ls_omck)
        $("button#viewers").html("Viewers: "+data.viewers)
      when "twitch"
        twitch = "<object type=\"application/x-shockwave-flash\" height=\"100%\" width=\"100%\" id=\"live_embed_player_flash\" data=\"http://www.twitch.tv/widgets/live_embed_player.swf?channel="+data.channel+"\" bgcolor=\"#000000\"><param name=\"allowFullScreen\" value=\"true\" /><param name=\"allowScriptAccess\" value=\"always\" /><param name=\"allowNetworking\" value=\"all\" /><param name=\"movie\" value=\"http://www.twitch.tv/widgets/live_embed_player.swf\" /><param name=\"wmode\" value=\"transparent\"><param name=\"flashvars\" value=\"hostname=www.twitch.tv&channel="+data.channel+"&auto_play=true&start_volume=100\" /></object>"
        $("#stream").html(twitch)
        $("button#viewers").html("Viewers: "+data.viewers)
      when "hd"
        if data.channel is "hdgames"
          InsertHD("live")
        else
          InsertHD("cinema")
      else
        $("#stream").html @hd_omck
    #$("button#viewers").html "Viewers: " + data.viewers
    #@current_channel = channel
  return

@popupChat = ->
  window.open "/irc", "popupChat", "height=500, width=350, resizable=1"
  return
@toggleSchedule = ->
  scheduleStatus = $("#schedule").css("display")
  if scheduleStatus is 'block'
    $("#schedule").hide()
    $("#hidecalendar").html "Show Schedule"

  else
    $("#schedule").show()
    $("#hidecalendar").html "Hide Schedule"
@toggleChat = (option) ->
  if option is 0
    $("#toggle-chat").attr("onclick", "toggleChat(1);").html "Show Chat"
    $("#chat").css "display", "none"
    $("#stream").attr "class", "col-md-12"
  else if option is 1
    $("#toggle-chat").attr("onclick", "toggleChat(0);").html "Hide Chat"
    $("#chat").css "display", "block"
    $("#stream").attr "class", "col-md-8"
  else
    console.log "ERROR!"
  return
@toggleDong = (option) ->
  if option is 0
    $("#toggle-dong").attr("onclick", "toggleDong(1);").html "Enlarge Screen"
    $("#streamBig").attr "class", "container"
    $.cookie "dong", "false"
  else if option is 1
    $("#toggle-dong").attr("onclick", "toggleDong(0);").html "Decrease Screen"
    $("#streamBig").attr "class", "container-fluid"
    $.cookie "dong", "true"
  else
    console.log "ERROR!"
  return

  return
@setSite = ->
  if typeof ($.cookie("dong")) is "undefined"
    toggleDong 0
  else toggleDong 1  if $.cookie("dong") is "true"
  return

@toggleBackground = ->
  bgStatus = $("#bg-hide").css("display")
  if bgStatus is "none"
    #console.log "show"
    $("#bg-hide").show()
  else
    #console.log "hide"
    $("#bg-hide").hide()
  return

@changeBackground = (url) ->
  $.cookie "background_image", url
  $.backstretch url
  return

@setBG = ->
  if typeof ($.cookie("background_image")) is "undefined"
    defaultImage = "/assets/bg/OMCKWall.jpg"
    $.cookie "background_image", defaultImage
    $.backstretch $.cookie("background_image")
  else
    $.backstretch $.cookie("background_image")
  return

$(document).ready ->
  setBG()
  if $(location).attr('pathname') is "/"
    setSite()
    MakeStreamMenu()
    if $(location).attr('hash').split('/')[1] is "channel"
      hash_stream = $(location).attr('hash').split("/")
      SelectStream(hash_stream[2]+'/'+hash_stream[3])
    refreshId = setInterval(->
      #UpdateChannel @current_channel
      MakeStreamMenu()
      return
    , 5000)
  $.ajaxSetup cache: false
  return
