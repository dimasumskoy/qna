# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $(document).on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

  App.cable.subscriptions.create('QuestionsChannel', {
    received: (data) ->
      question = $.parseJSON(data)
      title = question.title
      url = 'questions/' + question.id
      $('.questions-list').append(JST['question']({question_title: title, question_url: url}))
  })