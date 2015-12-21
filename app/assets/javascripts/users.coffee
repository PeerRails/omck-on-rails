@getUserList = ->
  $.get('/users', (data) ->
    if data.error is true
      console.log data.message
    else
      data.forEach (user) ->
        streamer = '<a class="btn btn-success" onclick="editUser("'+user.twitter_id+'/streamer")">Выдать права на стриме</a>'
        gmod = '<a class="btn btn-success" onclick="editUser("'+user.twitter_id+'/gmod">Выдать права на админку</a>'
        ungrant_streamer = '<a class="btn btn-danger" onclick="editUser("'+user.twitter_id+'/streamer">Забрать права на стрим</a>'
        ungrant_gmod = '<a class="btn btn-danger" onclick="editUser("'+user.twitter_id+'/gmod">Забрать права на админку</a>'
        if user.streamer is 1
          streamer = ungrant_streamer
        if user.gmod is 1
          gmod = ungrant_gmod
        $("#userList tr:last").after('<tr data-userID="'+user.twitter_id+'">
                  <td>'+user.name+'</td>
                  <td>@'+user.screen_name+'</td>
                  <td>Недоступно</td>
                  <td>
                    <div class="btn-group">
                      '+streamer+'
                      '+gmod+'
                    </div>
                  </td>
                  </tr>')
        return
    return
  )
@editUser = (input) ->
  return