base  = "http://hubstar.dev"

getRepo = ->
  document.location.href.replace(/https:\/\/github.com\/([^\/\#]+)\/([^\/\#]+).*/i, "$1/$2").trim()

successHandler = (result) ->
  console.debug("successHandler", result)
  if result? && !(result.error?)

    # Add the button next to Watchers/Forks
    setStat(result.stars, result.hubstarred)
  else
    setStat(0, false)

clickHandler = (starred) ->
  method = if starred then 'DELETE' else 'PUT'

  $.ajax("#{base}/star.json", {
    type: method
    data: $.param({
      id: getRepo()
    })
    success: successHandler
  })

initStat = ->
  li = $('<li class="hubstars"></li>')
  $('ul.repo-stats').prepend(li)

  $('li.hubstars a').live 'click', ->
    clickHandler($(this).parent().hasClass('hubstarred'))

    return false

setStat = (stars, starred) ->
  console.debug("setStat", stars, starred)
  li = $('li.hubstars')

  if starred
    li.addClass('hubstarred')
  else
    li.removeClass('hubstarred')

  a = $("<a href='#{base}/repositories/#{getRepo()}' class='tooltipped downwards' title='HubStars'>#{stars}</a>")
  a.css("background-image", "url('#{chrome.extension.getURL("images/stars.png")}')")

  li.html(a)

# Don't do anything unless we're on a public repo page
if $('body.vis-public').length > 0 && $('div.repohead').length > 0
  initStat()

  $.getJSON("#{base}/repositories/#{getRepo()}.json", successHandler)
