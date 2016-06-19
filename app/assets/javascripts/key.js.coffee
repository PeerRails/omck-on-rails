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
      $("#userinfo").data "key_id", data.key.id
      $("#inputGame").val(data.key.game)
      $("#inputMovie").val(data.key.movie)
      $("#inputStreamer").val(data.key.streamer)
    return
  )

@showKey = ->
  key = $("#userinfo").data "key_id"
  $('#showSmallKey').modal('show')
  $.get('/home/secret/'+key, (data) ->
      if data.error is true
        console.log data.message
      else
        $("#user-key").html("omcktv?key=" + data.key.secret)
      return
    )
  return

@showAnotherKey = (key) ->
  another_key = ""
  $.ajax
    url: '/home/secret/'+key
    type: 'GET'
    async:false
    success: (data) ->
      another_key = data.key.secret
      return
    error: (data) ->
      another_key = "Ошибка: " + data.message
      return
  return another_key

@postRegeneration = ->
  user = $("#userinfo").data("userid")
  $.post("/home/keys/regenerate", {key: {user_id: user}}, (data) ->
    if data.error is true
      createAlertBox("#help-account", "Ошибка создания ключа " + data.message)
    else
      $("#userinfo").data "key_id", data.key.id
      createAlertBox("#help-account", "Ключ пересоздан")
    return
    )

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
      createAlertBox("#help-account", "Сохраняется...")
      return
    success: (data) ->
      createAlertBox("#help-account", "Сохранено")
      return
    error: (data) ->
      createAlertBox("#help-account", "Ошибка: " + data.message)
      return
  return

@watchKeyInfo = ->
  $('.form-control').on 'input propertychange change', ->
    clearTimeout timeoutId
    timeoutId = setTimeout((->
      saveKeyData()
      return
    ), 1000)
    return

@updateKey = () ->
  form =
    key:
      id: $('#editKeyInfo').data("id")
      streamer: $('#inputKeyName').val()
      game: $('#inputKeyGame').val()
      movie: $('#inputKeyKinco').val()
  $.ajax
    url: '/home/keys/update'
    type: 'POST'
    data: form
    async:false
    success: (data) ->
      createAlertBox("#help-all", "Сохранено!")
      return
    error: (data) ->
      createAlertBox("#help-all", "Ошибка: " + data.message)
      return
  return
