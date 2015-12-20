@getVideoList = ->
  $.get('/home/video', (data) ->
    if data.error is true
      console.log data.message
    else
      data.forEach (vid) ->
        $("#videoList tr:last").after('<tr data-videoID="'+vid.token+'">
                  <td><input type="checkbox" name="tag_ids[]" id="tag_ids" value="'+vid.token+'"></td>
                  <td>'+vid.description+'</td>
                  <td>'+vid.created_at+'</td>
                  <td><a onclick="deleteVideos(\''+vid.token+'\')">Удалить</a></td>
                  </tr>')
        return
      $("#videoList").after('<a class="btn btn-danger" onclick="deleteCheckedVideos()">Удалить выбранное</a></td>')
    return
  )
@deleteVideos = (tokens) ->
  $.ajax
    url: '/home/video'
    type: 'DELETE'
    data: tag_tokens: tokens
    success: (data) ->
      console.log data
      data.videos.forEach (vid) ->
        if vid.error is true
          $('#responseVideo').append('<div class="text-danger"> Error: ' + vid.message + "</div>")
        else
          $('#responseVideo').html('<div class="text-success"> Deleted </div>')
          $('tr *[data-videoID="'+vid.token+'"]').remove()
      return
    error: (data) ->
      $('#responseVideo').html('<div class="text-danger"> Error: ' + data.message + "</div>")
      return
  return

@deleteCheckedVideos = ->
  $('input[name="tag_ids[]"]:checked').each ->
    console.log @value
    return