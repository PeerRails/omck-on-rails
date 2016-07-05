@getTokens = ->
  $.get('/home/token', (data) ->
    if data.error is true
      createAlertBox("#help-tokens", "Ошибка: " + data.message)
    else
      $("#tokenList").find("tr:gt(0)").remove()
      for token in data.tokens
        $("#tokenList tr:last").after('<tr data-tokenID="'+token.id+'" data-userID="'+token.user_id+'" data-tokenExpires="'+token.expires_at+'" data-tokenOwner="'+token.owner+'">
                  <td>'+token.owner+'</td>
                  <td>'+token.secret+'</td>
                  <td>'+token.expires_at+'</td>
                  <td><a href="#" onclick="expireToken(\''+token.id+'\')">Испарить</a></td>
                  </tr>')
    return
  )

@getAllTokens = ->
  $.get('/home/tokens', (data) ->
    if data.error is true
      createAlertBox("#help-tokens", "Ошибка: " + data.message)
    else
      $("#tokenList").find("tr:gt(0)").remove()
      for token in data.tokens
        $("#tokenList tr:last").after('<tr data-tokenID="'+token.id+'" data-userID="'+token.user_id+'" data-tokenExpires="'+token.expires_at+'" data-tokenOwner="'+token.owner+'">
                  <td>'+token.owner+'</td>
                  <td>'+token.secret+'</td>
                  <td>'+token.expires_at+'</td>
                  <td><a href="#" onclick="expireToken(\''+token.id+'\')">Испарить</a></td>
                  </tr>')
    return
  )

@addToken = ->
  $.ajax
    url: '/home/token/create'
    type: 'POST'
    beforeSend: (xhr) ->
      createAlertBox("#help-tokens", "Сохраняется...")
      return
    success: (data) ->
      createAlertBox("#help-tokens", "Сохранено. Новый токен: " + data.token.secret)
      getTokens()
      return
    error: (data) ->
      createAlertBox("#help-tokens", "Ошибка: " + data.message)
      return
  return

@expireToken = (id) ->
  $.ajax
    url: '/home/token/expire'
    type: 'POST'
    data: id: id
    beforeSend: (xhr) ->
      createAlertBox("#help-tokens", "Сохраняется...")
      return
    success: (data) ->
      createAlertBox("#help-tokens", "Испарен!")
      getTokens()
      return
    error: (data) ->
      createAlertBox("#help-tokens", "Ошибка: " + data.message)
      return
  return
