# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$("textarea").keyup ->
  if $("#tweet_tipe").is(":checked")
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
