# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $(document).on 'click', 'a.subscribe, a.unsubscribe', (e) ->
    $(this).hide()
    if $(this).hasClass('subscribe')
      $('a.unsubscribe').show()
    else if $(this).hasClass('unsubscribe')
      $('a.subscribe').show()