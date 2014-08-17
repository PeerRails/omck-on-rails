@ls_omck = '<object type="application/x-shockwave-flash" data="http://cdn.livestream.com/grid/LSPlayer.swf?channel=mc_mc_mc_omck&amp;color=0xe7e7e7&amp;autoPlay=true&amp;mute=false" height="100%" width="100%"><param name="movie" value="http://cdn.livestream.com/grid/LSPlayer.swf?channel=mc_mc_mc_omck&amp;color=0xe7e7e7&amp;autoPlay=true&amp;mute=false"><param name="wmode" value="transparent"><param name="allowFullscreen" value="true"></object>'
@hd_omck = "<div id=\"mediaspace\"></div>"
@tw_omck = "<object type=\"application/x-shockwave-flash\" height=\"100%\" width=\"100%\" id=\"live_embed_player_flash\" data=\"http://www.twitch.tv/widgets/live_embed_player.swf?channel=omcktv\" bgcolor=\"#000000\"><param name=\"allowFullScreen\" value=\"true\" /><param name=\"allowScriptAccess\" value=\"always\" /><param name=\"allowNetworking\" value=\"all\" /><param name=\"movie\" value=\"http://www.twitch.tv/widgets/live_embed_player.swf\" /><param name=\"wmode\" value=\"transparent\"><param name=\"flashvars\" value=\"hostname=www.twitch.tv&channel=omcktv&auto_play=true&start_volume=100\" /></object>"
@current_channel = "mc_mc_mc_omck"

@MakeStreamMenu = ->
  $.getJSON "/channel/live", (list) ->
    $("#stream-count").html list.length
    menu_list = []
    live_list = []
    official = ["mc_mc_mc_omck","hdvidya","hdkinco","omcktv" ]
    $("ul#stream-menu a").each (i) ->
      menu_list.push $(this).attr("id")  unless typeof ($(this).attr("id")) is "undefined"
      return
    channels = list.map (i) -> i.channel
    #console.log "List: " + menu_list
    #console.log "List 2: " + channels
    if list.length is 0
      menu_list.map (li) ->
        ChangeMenuItem(li, "", 0)
    else
      list.map (chan) ->
        #console.log chan.channel in menu_list
        if chan.channel not in menu_list and chan.channel not in official
          #console.log "NO"
          AddMenuChannel chan.channel, chan.streamer, chan.status, chan.viewers, chan.title
        else if chan.channel in menu_list
          ChangeMenuChannel chan.channel, chan.status, chan.viewers, chan.title
          #console.log "YES"
        else if chan.channel in official
          ChangeMenuChannel chan.channel, chan.status, chan.viewers, chan.title
      official.map (chan) ->
        if chan not in channels
          ChangeMenuChannel chan, "", 0, ""
      menu_list.map (chan) ->
        if chan not in channels
          DeleteChannelFromMenu chan


#@NullOfficial = (channel) ->

@ChangeMenuChannel = (channel, live, viewers, title) ->
  $("#live-"+channel).html(live.toUpperCase())
  $("#viewers-"+channel).html(viewers)
  $("p#title-"+channel).html title

@AddMenuChannel = (channel, streamer, live, viewers, title) ->

  new_channel = '<a href="#" class="list-group-item" id="'+channel+'" onclick="SelectStream(\''+channel+'\');">'+
                '<span class="badge pull-right">'+
                '<i class="fa fa-eye" id="viewers-'+channel+'">'+viewers+'</i>'+
                '</span>'+
                streamer+
                '<span class="label label-danger pull-right" id="live-'+channel+'"> '+live.toUpperCase()+'</span>'+
                '<p id="title-'+channel+'">'+
                title+
                '</p>'+
                '</a>';
  $("ul#stream-menu").append new_channel

@DeleteChannelFromMenu = (channel) ->
  $("a#"+channel).remove()

@UpdateChannel = ->
  channel = @current_channel
  $.getJSON "/channel/"+channel, (data) ->
    $("button#viewers").html "Viewers: " + data.viewers

#@GetChannel = (channel) ->

@SelectStream = (channel) ->
  $.getJSON "/channel/"+channel, (data) ->
    switch data.service
      when "livestream"
        ls_omck = '<object type="application/x-shockwave-flash" data="http://cdn.livestream.com/grid/LSPlayer.swf?channel=mc_mc_mc_omck&amp;color=0xe7e7e7&amp;autoPlay=true&amp;mute=false" height="100%" width="100%"><param name="movie" value="http://cdn.livestream.com/grid/LSPlayer.swf?channel=mc_mc_mc_omck&amp;color=0xe7e7e7&amp;autoPlay=true&amp;mute=false"><param name="wmode" value="transparent"><param name="allowFullscreen" value="true"></object>'
        $("#stream").html(ls_omck)
        $("button#viewers").html("Viewers: "+data.viewers)
      when "twitch"
        twitch = "<object type=\"application/x-shockwave-flash\" height=\"100%\" width=\"100%\" id=\"live_embed_player_flash\" data=\"http://www.twitch.tv/widgets/live_embed_player.swf?channel="+data.channel+"\" bgcolor=\"#000000\"><param name=\"allowFullScreen\" value=\"true\" /><param name=\"allowScriptAccess\" value=\"always\" /><param name=\"allowNetworking\" value=\"all\" /><param name=\"movie\" value=\"http://www.twitch.tv/widgets/live_embed_player.swf\" /><param name=\"wmode\" value=\"transparent\"><param name=\"flashvars\" value=\"hostname=www.twitch.tv&channel="+data.channel+"&auto_play=true&start_volume=100\" /></object>"
        $("#stream").html(twitch)
        $("button#viewers").html("Viewers: "+data.viewers)
      when "hd"
        hd_omck = '<div id="mediaspace"></div>'
        if data.channel is "hdgames"
          omck = "live"
        else
          omck = "cinema"
        $("#stream").html hd_omck
        jwplayer("mediaspace").setup
          flashplayer: "player.swf"
          autostart: "true"
          autoplay: "true"
          skin: "stormtrooper.zip"
          loop: "true"
          dock: "false"
          icons: "false"
          file: "omcktv"
          streamer: "rtmp://localhost/"+omck
          controlbar: "bottom"
          width: "100%"
          height: "100%"
          image: "assets/bg/omck.jpg"
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
    console.log "show"
    $("#bg-hide").show()
  else
    console.log "hide"
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
  if $(location).attr 'pathname' == "/"
    setSite()
    MakeStreamMenu()
    refreshId = setInterval(->
      UpdateChannel @current_channel
      MakeStreamMenu()
      return
    , 5000)
  $.ajaxSetup cache: false
  return
