@getUserList = ->
  $.get('/users', (data) ->
    if data.error is true
      console.log data.message
    else
      data.forEach (user) ->
        $("#userList tr:last").after('<tr data-userid="'+user.twitter_id+'">
                  <td>'+user.name+'</td>
                  <td>@'+user.screen_name+'</td>
                  <td>Недоступно</td>
                  <td>
                    <div class="checkbox">
                      <label>
                        <input data-userid="'+user.twitter_id+'" id="streamer_role" type="checkbox" '+('checked' if user.streamer == true)+'> Стример
                        <input data-userid="'+user.twitter_id+'" id="admin_role" type="checkbox" '+('checked' if user.gmod == true)+'> Админ
                      </label>
                    </div>
                  </td>
                  <td id="responsePriv">
                  </td>
                  </tr>')
        return
    return
  )
@editUser = (input) ->
  #$('[data-userid="953869526"] #responsePriv').val()
  return
@grantUser = (input) ->
  $('[data-userid="'+input.userid+'"] #responsePriv').html('Loading...')
  if input.id == "streamer_role"
    params =
      permissions:
        streamer: input.checked == true ? 1 : 0
  else if input.id == "admin_role"
    params =
      permissions:
        gmod: input.checked == true ? 1 : 0
  else
    $("#responseUser").html('<div class="text-danger"> Error granting access</div>')
    return false
  $.post('/user/'+input.userid+'/grant', params, (data) ->
    if data.error is true
      $('[data-userid="'+input.userid+'"] #responsePriv').html('<div class="text-danger"> Error: ' + data.message + '</div>')
    else
      $('[data-userid="'+input.userid+'"] #responsePriv').html('<div class="text-success"> Saved </div>')
  )
  return
@inviteUser = ->
  invitee =
    screen_name: $('#inputTwitter').val()
  $.post("/user/invite", invitee, (user) ->
    if user.error is true
      $('#responseInvite').html('<div class="text-danger">Error: '+user.message+'</div>')
    else
      $('#responseInvite').html('<div class="text-success"> Stremaer invited. Please tell him to visit this page!</div>')
      if $('[data-userid="'+user.twitter_id+'"]').length == 0
        $("#userList tr:first").after('<tr data-userid="'+user.twitter_id+'">
                  <td>'+user.name+'</td>
                  <td>@'+user.screen_name+'</td>
                  <td>Недоступно</td>
                  <td>
                    <div class="checkbox">
                      <label>
                        <input data-userid="'+user.twitter_id+'" id="streamer_role" type="checkbox" '+('checked' if user.streamer == true)+'> Стример
                        <input data-userid="'+user.twitter_id+'" id="admin_role" type="checkbox" '+('checked' if user.gmod == true)+'> Админ
                      </label>
                    </div>
                  </td>
                  <td id="responsePriv">
                  </td>
                  </tr>')
      else
        $('[data-userid="'+user.twitter_id+'"] #streamer_role').val = 1
        $('[data-userid="'+user.twitter_id+'"] #responsePriv').html('<div class="text-success"> Saved </div>')
    return
    )
  return
