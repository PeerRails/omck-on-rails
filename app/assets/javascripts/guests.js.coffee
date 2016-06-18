@getGuests = ->
  $.get('/home/guest_keys', (data) ->
    if data.error is true
      createAlertBox("#help-guest", "Ошибка: " + data.message)
    else
      $("#guestList").find("tr:gt(0)").remove()
      for guest in data.keys
        $("#guestList tr:last").after('<tr data-guestID="'+guest.id+'" data-guestStreamer="'+guest.streamer+'" data-guestGame="'+guest.game+'" data-guestMovie="'+guest.movie+'">
                  <td>'+guest.streamer+'</td>
                  <td>'+guest.created_by_name+'</td>
                  <td>'+guest.game+'</td>
                  <td>'+guest.movie+'</td>
                  <td>'+guest.expires+'</td>
                  <td><a href="#" onclick="deleteGuest(\''+guest.id+'\')">Удалить</a><br>
                  <a href="#" onclick="showGuestKey(\''+guest.id+'\')">Показать ключ</a></td>
                  </tr>')
    return
  )

@addGuest = ->
  $("#showGuestInvite").modal('show')
  return

@createGuest = ->
  form =
    key:
      streamer: $('#inputGuestName').val()
      game: $('#inputGuestGame').val()
      movie: $('#inputGuestKinco').val()
  $.ajax
    url: '/home/keys/create/guest'
    type: 'POST'
    data: form
    beforeSend: (xhr) ->
      createAlertBox("#help-guest", "Сохраняется...")
      return
    success: (data) ->
      createAlertBox("#help-guest", "Сохранено. Новый ключ: " + showAnotherKey(data.key.id))
      getGuests()
      return
    error: (data) ->
      createAlertBox("#help-guest", "Ошибка: " + data.message)
      return
  return

@showGuestKey = (key) ->
  guest_key = showAnotherKey(key)
  createAlertBox("#help-guest", "Ключ: " + guest_key)
  return

@deleteGuest = (id="") ->
  if id == ""
  else
    $.ajax
      url: '/home/keys/expire/guest'
      type: 'POST'
      data: id: id
      success: (data) ->
        createAlertBox("#help-guest", "Удалено")
        getGuests()
        return
      error: (data) ->
        createAlertBox("#help-guest", data.message)
  return

@editGuestKey = (key) ->
  $("#showEditKey").modal('show')
  $("#inputKeyName").val($('*[data-guestID="'+key+'"]').data("gueststreamer"))
  $("#inputKeyGame").val($('*[data-guestID="'+key+'"]').data("guestgame"))
  $("#inputKeyKinco").val($('*[data-guestID="'+key+'"]').data("guestmovie"))
  $("#editKeyInfo").data "id", key
  return