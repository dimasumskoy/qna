# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $(document).on 'click', 'a.revote-question', (e) ->
    $(this).hide()
  .bind 'ajax:success', (e, data, status, xhr) ->
    rating = $.parseJSON(xhr.responseText)
    $('div.current_rating').html(rating)

  $(document).on 'click', 'a.vote-up-question, a.vote-down-question', (e) ->
    $('.rating a.revote-question').show()
    $(this).bind 'ajax:success', (e, data, status, xhr) ->
      rating = $.parseJSON(xhr.responseText)
      $('div.current_rating').html(rating)
    .bind 'ajax:error', (e, xhr, data, error) ->
      $('div.rating_errors').html(xhr.responseText)