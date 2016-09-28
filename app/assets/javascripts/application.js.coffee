//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require cookie-eater
//= require jquery.backstretch.min

@createAlertBox = (helpbox, message) ->
  $("span.help-block"+helpbox).html('<div class="alert alert-dismissible alert-info"><button class="close" data-dismiss="alert" type="button">&times;</button><strong>'+message+'</strong></div>')
  return