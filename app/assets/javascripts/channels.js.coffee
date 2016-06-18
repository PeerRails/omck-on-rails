@getChannels = ->
  $.get('/channel/all', (data) ->
    if data.error is true
      console.log data.message
    else
      $("#channelList").find("tr:gt(0)").remove()
      for ch in data.channels
        $("#channelList tr:last").after('<tr data-channelID="'+ch.service+'/'+ch.channel+'">
                  <td>'+ch.channel+'</td>
                  <td>'+ch.service+'</td>
                  <td>'+ch.game+'</td>
                  <td>'+ch.title+'</td>
                  <td><a href="#" onclick="deleteChannel(\''+ch.service+'/'+ch.channel+'\')">Удалить</a></td>
                  </tr>')
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
      $("#channelList tr:last").after('<tr data-channelID="'+data.channel.service+'/'+data.channel.channel+'">
                  <td>'+data.channel.channel+'</td>
                  <td>'+data.channel.service+'</td>
                  <td>'+data.channel.game+'</td>
                  <td>'+data.channel.title+'</td>
                  <td><a href="#" onclick="deleteChannels(\''+data.channel.service+'/'+data.channel.channel+'\')">Удалить</a></td>
                  </tr>')
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
        createAlertBox("#help-channels", data.message)
        return
  return