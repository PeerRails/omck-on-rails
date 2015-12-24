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
      $('#responseKeyData').html 'Saving...'
      return
    success: (data) ->
      $('#responseKeyData').html('<div class="text-success"> Saved </div>')
      return
    error: (data) ->
      $('#responseKeyData').html('<div class="text-danger"> Error: ' + data.message + "</div>")
      return
  return

@getGuestList = ->
  $.get('/home/guest_keys', (data) ->
    if data.error is true
      console.log data.message
    else
      data.forEach (user) ->
        $("#guestList tr:last").after('<tr data-guestid="'+user.guest_id+'">
                  <td>'+user.game+'</td>
                  <td>'+user.movie+'</td>
                  <td></td>
                  <td>'+user.created_by_name+'</td>
                  <td>
                    <button class="btn btn-danger" onclick="postGuestExpire('+user.guest_id+')" title="Удалить"><i class="fa fa-trash"></i></a>
                  </td>
                  <td id="responseGuest">
                  </td>
                  </tr>')
        return
    return
  )

@inviteGuest = () ->
  keys =
    key:
      streamer: $('#inputGuestName').val()
      game: $('#inputGuestGame').val()
      movie: $('#inputGuestMovie').val()
  $.post("/home/keys/create/guest", keys, (data) ->
    if data.error is true
      $('#responseGuest').html('<div class="text-danger">Error: '+data.message+'</div>')
    else
      $('#responseGuest').html('<div class="text-success"> Guest added and his key: <b>'+data.secret+' </b>. Key wont appear again, save it!</div>')
      $("#guestList tr:first").before('<tr data-guestid="'+data.guest_id+'">
                <td>'+data.game+'</td>
                <td>'+data.movie+'</td>
                <td></td>
                <td>'+data.created_by_name+'</td>
                <td>
                  <button class="btn btn-danger" onclick="postGuestExpire('+data.guest_id+')" title="Удалить"><i class="fa fa-trash"></i></a>
                </td>
                <td id="responseGuest">
                </td>
                </tr>')
    return
    )

@postGuestExpire = (guest) ->
  $.post("/home/keys/expire/guest", {id: guest}, (data) ->
    if data.error is true
      $('#responseGuest').html('<div class="text-danger">Error: '+data.message+'</div>')
    else
      $('*[data-guestid="'+guest+'"]').remove()
      $('#responseGuest').html('<div class="text-success"> Guest removed</div>')
    return
    )
$('.form-control').on 'input propertychange change', ->
  $('#responseKeyDaya').html 'Data changed...'
  clearTimeout timeoutId
  timeoutId = setTimeout((->
    saveKeyData()
    return
  ), 1000)
  return
