@getUserList = ->
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
