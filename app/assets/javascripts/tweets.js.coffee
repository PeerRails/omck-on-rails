@readyTweetText = ->
  $("#inputTweet").on 'input propertychange change', ->
    if $("#optionsOwn").is(":checked")
      count = 140
    else if $("#optionsKinco").is(":checked") or $("#optionsGame").is(":checked")
      count = 105
    else
      count = 99
    length = count - $(this).val().length
    if length <= 0 and $("#tweet-count").attr("class") is "text-success"
      $("#tweet-count").toggleClass "text-success text-danger"
      $(".subm").prop "disabled", true
    else if length >= 0 and $("#tweet-count").attr("class") is "text-danger"
      $("#tweet-count").toggleClass "text-danger text-success"
      $(".subm").prop "disabled", false
    $("#tweet-count").text length
    return

@postTweetUpdate = ->
  tweet =
    kinco: $("#optionsKinco").is(":checked")
    games: $("#optionsGame").is(":checked")
    own: $("#optionsOwn").is(":checked")
    comment: $("#inputTweet").val()
  console.log tweet
  if tweet.comment == ""
    createAlertBox("#help-tweet", "Пустое поле!")
  else
    if tweet.kinco
      tweet.comment = "Стрим на http://omck.tv/#/channel/hdgames || " + tweet.comment
    else if tweet.games
      tweet.comment = "Стрим на http://omck.tv/#/channel/hdcinema || " + tweet.comment
    else if tweet.own
      tweet.comment = tweet.comment
    $.post('/home/tweets', {tweet: tweet}, (data) ->
      if data.error is true
        createAlertBox("#help-tweet", "Ошибка! : " + data.message)
      else
        createAlertBox("#help-tweet", "Отправлено!")
      return
      )
    return

