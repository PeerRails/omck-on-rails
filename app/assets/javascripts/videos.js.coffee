@getVideos = ->
  $.get('/home/video', (data) ->
    if data.error is true
      console.log data.message
    else
      $("#videoList").find("tr:gt(0)").remove()
      for vid in data.videos
        $("#videoList tr:last").after('<tr data-videoID="'+vid.token+'">
                  <td><input type="checkbox" name="tag_ids[]" id="tag_ids" value="'+vid.token+'"></td>
                  <td>'+vid.username+'</td>
                  <td>'+vid.game+'</td>
                  <td>'+vid.created_at+'</td>
                  <td><a href="#" onclick="deleteVideos(\''+vid.token+'\')">Удалить</a></td>
                  </tr>')
    return
  )

@deleteVideos = (tokens="") ->
  selectedVideos = []
  if tokens == ""
    $('input[name="tag_ids[]"]:checked').each ->
      selectedVideos.push @value
  else
    selectedVideos.push tokens
  $.ajax
    url: '/home/video'
    type: 'DELETE'
    data: tag_tokens: selectedVideos
    success: (data) ->
      data.videos.forEach (vid) ->
        if vid.error is true
          createAlertBox("#help-videos", vid.message)
        else
          createAlertBox("#help-videos", "Удалено")
          $('tr *[data-videoID="'+vid.token+'"]').remove()
      return
    error: (data) ->
      createAlertBox("#help-videos", data.message)
      return
  return

