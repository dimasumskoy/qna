# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $(document).on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  questionId = $('.question').data('questionId')

  App.cable.subscriptions.create { channel: "AnswersChannel", question_id: questionId },
    received: (data) ->
      answer = $.parseJSON(data)
      body = answer.body
      console.log body