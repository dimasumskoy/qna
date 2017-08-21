$(document).on 'turbolinks:load', ->
  $(document).ajaxError (e, xhr, data, error) ->
    if gon.current_user == undefined
      alert(xhr.responseJSON.error)
    else
      alert(xhr.responseText)