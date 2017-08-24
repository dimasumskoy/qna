# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  questionId = $('.question').data('questionId')

  App.cable.subscriptions.create { channel: 'CommentsChannel', question_id: questionId },
    received: (data) ->
      comment = $.parseJSON(data)
      type = comment['commentable_type'].toLowerCase()
      id = comment['commentable_id']
      if gon.current_user == undefined or gon.current_user.id != comment.user_id
        $("div##{type}-#{id} .comments").append(JST['templates/comment']({comment: comment}))