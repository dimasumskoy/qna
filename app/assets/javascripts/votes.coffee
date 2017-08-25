# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  update_rating = (object) ->
    object.bind 'ajax:success', (e, data, status, xhr) ->
      votable = $.parseJSON(xhr.responseText)
      votableKlass = object.data('klass')
      votablePath = 'div#rating-' + votableKlass + '-' + votable.id
      $(votablePath + ' ' + '.current_rating').html(votable.rating)

  $(document).on 'click', 'a.vote-up, a.vote-down', (e) ->
    update_rating($(this))
    $('a.revote').show()

  $(document).on 'click', 'a.revote', (e) ->
    update_rating($(this))
    $(this).hide()