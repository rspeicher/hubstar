clickHandler = (a) ->
  starred = $(a).parent().hasClass('hubstarred')
  method = if starred then 'DELETE' else 'PUT'

  $.ajax("/star.json", {
    type: method
    data: $.param({
      id: $(a).data('id')
    })
    success: (result) ->
      if result.error?
        alert("HubStar error: #{result.error}")
      else
        $(a).text(result.stars)
        $(a).parent().toggleClass('hubstarred')
  })

  false

$ ->
  $('.repo-stats .hubstars a').live 'click', ->
    clickHandler(this)
