@getUsers = ->
  $.get('/home/streamer_keys', (data) ->
    if data.error is true
      createAlertBox("#help-users", "Ошибка: " + data.message)
    else
      $("#userList").find("tr:gt(0)").remove()
      for user in data.keys
        after_text = '<tr data-userID="'+user.user_id+'" data-userStreamer="'+user.streamer+'"
                      data-userGame="'+user.game+'" data-userMovie="'+user.movie+'">
                      <td>'+user.streamer+'</td>
                      <td><a href="http://twitter.com/'+user.created_by_screen_name+'">@'+user.created_by_screen_name+'</a></td>
                      <td>'+user.game+'</td>
                      <td>'+user.movie+'</td>
                      <td>'+user.expires+'</td>'
        if $('#accountInfo').data('streamer') == 1 or $('#accountInfo').data('gmod') == 1
          after_text = after_text + '<td><a href="#" onclick="editUser(\''+user.user_id+'\')">Редактировать права</a></td>'
        after_text = after_text + '</tr>'
        $("#userList tr:last").after(after_text)
    return
  )

@addUser = ->
  $("#showUserInvite").modal('show')
  return

@inviteUser = ->
  form =
    user:
      screen_name: $('#inputUserTwitter').val()
  $.ajax
    url: '/user/invite'
    type: 'POST'
    data: form
    beforeSend: (xhr) ->
      createAlertBox("#help-users", "Сохраняется...")
      return
    success: (data) ->
      createAlertBox("#help-users", "Приглашен.")
      return
    error: (data) ->
      createAlertBox("#help-users", "Ошибка: " + data.message)
      return
  getUsers()
  return

@regenerateUser = (id="") ->
  if id == ""
    createAlertBox("#help-users", "Некого испарять!")
  else
    $.ajax
      url: '/home/keys/regenerate'
      type: 'POST'
      data: id: id
      success: (data) ->
        createAlertBox("#help-users", "Испарено")
        getUsers()
        return
      error: (data) ->
        createAlertBox("#help-users", data.message)
  return

@editUser = (id) ->
  $("#editUserGrants").modal('show')
  $("#userIdInfo").data "id", id
  $.get('/user/'+id, (data) ->
    console.log data
    $("#inputUserStreamerOption").val(1) if data.user.streamer == true
    $("#inputUserAdminOption").val(1) if data.user.gmod == true
    return
    )
  return

@grantUser = ->
  id = $("#userIdInfo").data "id"
  form =
    user:
      streamer: $("#inputUserStreamerOption").val()
      gmod: $("#inputUserAdminOption").val()
  $.ajax
    url: 'user/'+id+'/grant'
    type: 'POST'
    data: form
    success: (data) ->
      createAlertBox("#help-users", "Отредактировано")
      getUsers()
      return
    error: (data) ->
      createAlertBox("#help-users", data.message)
  $("#editUserGrants").modal('hide')
  return
