@getGuests = ->
  $.get('/home/guest_keys', (data) ->
    if data.error is true
      createAlertBox("#help-guests", "Ошибка: " + data.message)
    else
      $("#guestList").find("tr:gt(0)").remove()
      for guest in data.keys
        after_text = '<tr data-guestID="'+guest.id+'" data-guestStreamer="'+guest.streamer+'" data-guestGame="'+guest.game+'"
                      data-guestMovie="'+guest.movie+'">
                      <td>'+guest.streamer+'</td>
                      <td>'+guest.created_by_name+'</td>
                      <td>'+guest.game+'</td>
                      <td>'+guest.movie+'</td>
                      <td>'+guest.expires+'</td>'
        if $('#accountInfo').data('streamer') == 1 or $('#accountInfo').data('gmod') == 1
          after_text = after_text + '<td><a href="#" onclick="deleteGuest(\''+guest.id+'\')">Удалить</a><br>
                                    <a href="#" onclick="showGuestKey(\''+guest.id+'\')">Показать ключ</a></td>'
        after_text = after_text + '</tr>'
        $("#guestList tr:last").after(after_text)
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
  $.ajax(
    url: '/home/keys/create/guest'
    type: 'POST'
    data: form
    beforeSend: (xhr) ->
      createAlertBox("#help-guests", "Сохраняется...")
      return
    ).done( (data) ->
      createAlertBox("#help-guests", "Сохранено. Новый ключ: " + showAnotherKey(data.key.id))
      getGuests()
      return
    ).error( (data) ->
      createAlertBox("#help-guests", "Ошибка!")
      return)
  $("#showGuestInvite").modal('hide')
  return


@showGuestKey = (key) ->
  createAlertBox("#help-guests", "Ключ: " + showAnotherKey(key))
  return

@deleteGuest = (id="") ->
  if id == ""
  else
    $.ajax
      url: '/home/keys/expire/guest'
      type: 'POST'
      data: id: id
      success: (data) ->
        createAlertBox("#help-guests", "Удалено")
        getGuests()
        return
      error: (data) ->
        createAlertBox("#help-guests", data.message)
  return

@editGuestKey = (key) ->
  $("#showEditKey").modal('show')
  $("#inputKeyName").val($('*[data-guestID="'+key+'"]').data("gueststreamer"))
  $("#inputKeyGame").val($('*[data-guestID="'+key+'"]').data("guestgame"))
  $("#inputKeyKinco").val($('*[data-guestID="'+key+'"]').data("guestmovie"))
  $("#editKeyInfo").data "id", key
  return