# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('a.vote-up-question').bind 'ajax:success', (e, data, status, xhr) ->
    rating = $.parseJSON(xhr.responseText)
    $('p.current_rating').html(rating)