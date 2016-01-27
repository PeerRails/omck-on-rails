$("#tweetControl #inputTweet").on 'input propertychange change', ->
  if $("#tweet_own").is(":checked")
    count = 140
  else
    count = 99
  length = count - $(this).val().length
  if length <= 0 and $("#count").attr("class") is "text-success"
    $("#count").toggleClass "text-success text-danger"
    $(".subm").prop "disabled", true
  else if length >= 0 and $("#count").attr("class") is "text-danger"
    $("#count").toggleClass "text-danger text-success"
    $(".subm").prop "disabled", false
  $("#count").text length
  return

@postTweetUpdate = ->
  tweet =
    own: $("#tweet_own").is(":checked")
    comment: $("#inputTweet").val()
  if tweet.comment == ""
    $("#responseTweet").html("<div class='text-danger'>Пустое поле!</div>")
  else
    $.post('/home/user/tweet', {tweet: tweet}, (data) ->
      if data.error is true
        $("#responseTweet").html("<div class='text-danger'>"+data.message+"</div>")
      else
        $("#responseTweet").html("<div class='text-success'>Твит обновлен! Статус: '"+data.text+"'</div>")
        console.log tweet
      return
    )
