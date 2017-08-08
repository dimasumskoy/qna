# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  update_rating = (object) ->
    object.bind 'ajax:success', (e, data, status, xhr) ->
      votable = $.parseJSON(xhr.responseText)
      $('div.current_rating').html(votable.rating)
    .bind 'ajax:error', (e, xhr, data, error) ->
      $('div.rating_errors').html(xhr.responseText)

  $(document).on 'click', 'a.vote-up, a.vote-down', (e) ->
    update_rating($(this))
    $('div.rating a.revote').show()

  $(document).on 'click', 'a.revote', (e) ->
    update_rating($(this))
    $(this).hide()