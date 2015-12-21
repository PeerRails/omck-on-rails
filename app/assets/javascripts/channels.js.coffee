@getChannelList = ->
  $.get('/channel/all', (data) ->
    if data.error is true
      console.log data.message
    else
      data.forEach (ch) ->
        if ch.service is "twitch"
          live = '<span class="label label-danger">Офлайн</span>'
          if ch.live is true
            live = '<span class="label label-success">Стрим</span>'
          $("#channelList tr:last").after('<tr data-channel="'+ch.channel+'" data-service="'+ch.service+'" data-allTogether="'+ch.service+'/'+ch.channel+'">
                    <td>'+ch.channel+'</td>
                    <td>'+ch.streamer+'</td>
                    <td>'+ch.title+'</td>
                    <td><span class="label label-primary">'+ch.service+'</span></td>
                    <td>'+live+'</td>
                    <td><a onclick="deleteChannel(\''+ch.service+'/'+ch.channel+'\')">Удалить</a></td>
                    </tr>')
          return
    return
  )
@deleteChannel = (input) ->
  channel =
    channels:
      service: input.split("/")[0]
      channel: input.split("/")[1]
  $.ajax
    url: '/channel/remove'
    type: 'DELETE'
    data: channel
    success: (data) ->
      if data.error is true
        $('#responseChannel').append('<div class="text-danger"> Error: ' + data.message + "</div>")
      else
        $('#responseChannel').html('<div class="text-success"> Deleted </div>')
        $('*[data-allTogether="'+data.service+'/'+data.channel+'"]').remove()
      return
    error: (data) ->
      $('#responseChannel').html('<div class="text-danger"> Error: ' + data.message + "</div>")
      return
  return

@addChannel = ->
  channel =
    channels:
      channel: $('#inputChannel').val()
      streamer: $('#inputChannelStreamer').val()
      service: 'twitch'
  $.post('/channel/new', channel, (data) ->
    if data.error is true
      $('#responseChannel').append('<div class="text-danger"> Error: ' + data.message + "</div>")
    else
      $('#responseChannel').html('<div class="text-success"> Added </div>')
      $("#channelList tr:first").after('<tr data-channel="'+data.channel+'" data-service="'+data.service+'" data-allTogether="'+data.service+'/'+data.channel+'">
                <td>'+data.channel+'</td>
                <td>'+data.streamer+'</td>
                <td>'+data.title+'</td>
                <td><span class="label label-primary">'+data.service+'</span></td>
                <td><span class="label label-danger">Офлайн</span></td>
                <td><a onclick="deleteChannel(\''+data.service+'/'+data.channel+'\')">Удалить</a></td>
                </tr>')
      $('#inputChannelStreamer').val('Dwarf')
      $('#inputChannel').val('dwarf')
    return
    )
