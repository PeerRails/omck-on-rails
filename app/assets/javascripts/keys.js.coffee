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
    console.log data
    if data.error is true
      console.log data.message
    else
      $("#input-key").append(data.key)
    return
  )

$(document).ready ->
  if location.pathname == "/home"
    getUser $("#userinfo").data("twitterid")
    getUserKey
  return
