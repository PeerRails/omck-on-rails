timeoutId = undefined
@getUser = (twitter_id) ->
  $.get('/user/'+twitter_id, (data) ->
    if data.error is true
      console.log data.message
    else
      $("#input-name").append(data.name)
      $("#input-screen").append(data.screen_name)
      if data.streamer is 1
        $("#input-priv").append('<span class="label label-success">Стример</i>')
      if data.gmod is 1
        $("#input-priv").append('<span class="label label-danger">Админ</i>')
      $("#input-img").append('<img src="'+data.profile_image_url+'"></img>')
    return
  )

@getUserKey = ->
  $.get('/home/your_keys', (data) ->
    if data.error is true
      console.log data.message
    else
      $("#input-key").append(data.secret)
      $("#inputGame").val(data.game)
      $("#inputMovie").val(data.movie)
      $("#inputStreamer").val(data.streamer)
    return
  )

@postRegeneration = ->
  user = $("#userinfo").data("userid")
  $.post("/home/keys/regenerate", {key: {user_id: user}}, (data) ->
    if data.error is true
      console.log data.message
    else
      console.log data
      $("#input-key").text(data.secret)
    return
    )

$(document).ready ->
  if location.pathname == "/home"
    getUser $("#userinfo").data("twitterid")
    getUserKey()
    getVideoList()
  return

@saveKeyData = ->
  form =
    key:
      user_id: $("#userinfo").data("userid")
      streamer: $('#inputStreamer').val()
      game: $('#inputGame').val()
      movie: $('#inputMovie').val()
  $.ajax
    url: '/home/keys/update'
    type: 'POST'
    data: form
    beforeSend: (xhr) ->
      $('#responseKeyDaya').html 'Saving...'
      return
    success: (data) ->
      $('#responseKeyDaya').html('<div class="text-success"> Saved </div>')
      return
    error: (data) ->
      $('#responseKeyDaya').html('<div class="text-danger"> Error: ' + data.message + "</div>")
      return
  return

$('.form-control').on 'input propertychange change', ->
  $('#responseKeyDaya').html 'Data changed...'
  clearTimeout timeoutId
  timeoutId = setTimeout((->
    saveKeyData()
    return
  ), 1000)
  return
