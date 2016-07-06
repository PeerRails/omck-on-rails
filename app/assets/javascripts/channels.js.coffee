@getChannels = ->
  $.get('/channel/all', (data) ->
    if data.error is true
      console.log data.message
    else
      $("#channelList").find("tr:gt(0)").remove()
      for ch in data.channels
        if ch.service != "hd" && ch.service != "livestream" && ch.channel != "omcktv"
          after_text = '<tr data-channelID="'+ch.service+'/'+ch.channel+'">
                    <td>'+ch.channel+'</td>
                    <td>'+ch.service+'</td>
                    <td>'+ch.game+'</td>
                    <td>'+ch.title+'</td>'
          if $('#accountInfo').data('streamer') == 1 or $('#accountInfo').data('gmod') == 1
            after_text = after_text + '<td><a href="#" onclick="deleteChannel(\''+ch.service+'/'+ch.channel+'\')">Удалить</a></td>'
          after_text = after_text + '</tr>'
          $("#channelList tr:last").after(after_text)
    return
  )

@addChannel = ->
  $("#showChannelCreate").modal('show')
  return

@createChannel = ->
  form =
    channels:
      channel: $("#inputChannelName").val()
      streamer: $('#inputChannelStreamer').val()
      service: $('#inputChannelServiceOption').text()
  $.ajax
    url: '/channel/new'
    type: 'POST'
    data: form
    beforeSend: (xhr) ->
      createAlertBox("#help-channels", "Сохраняется...")
      $("#showChannelCreate").modal('hide')
      return
    success: (data) ->
      createAlertBox("#help-channels", "Сохранено")
      getChannels()
      return
    error: (data) ->
      createAlertBox("#help-channels", "Ошибка: " + data.message)
      return
  return

@deleteChannel = (channel="") ->
  selectedChannels = []
  if channel == ""
    createAlertBox("#help-channels", "Ничего не выбрано")
  else
    ch = channel.split("/")
    $.ajax
      url: '/channel/'+ch[0]+'/'+ch[1]+'/remove'
      type: 'DELETE'
      success: (data) ->
        createAlertBox("#help-channels", "Удалено")
        getChannels()
        return
      error: (data) ->
        createAlertBox("#help-channels", "Ошибка!")
        return
  return